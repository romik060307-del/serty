-- OHLI Social v3.0.0: profile photo scopes, expiring view-once media access,
-- saved Story collections, group polls and Channel reactions.
-- This migration is for the optional PostgreSQL target schema only. The current
-- Android APK stores these records in app-private JSON files and does not execute SQL.
BEGIN;

-- Keep independent Chat and Social profile images; a sync mode can update both.
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_photo_mode varchar(10) NOT NULL DEFAULT 'both'
  CHECK (profile_photo_mode IN ('both','social','chat'));
ALTER TABLE users ADD COLUMN IF NOT EXISTS social_avatar_media_id uuid REFERENCES media_objects(id) ON DELETE SET NULL;
ALTER TABLE users ADD COLUMN IF NOT EXISTS chat_avatar_media_id uuid REFERENCES media_objects(id) ON DELETE SET NULL;

-- View-once is a server-enforced message property. The access-key hash is short-lived
-- and only issued after the recipient consumes the one-time open action.
ALTER TABLE messages ADD COLUMN IF NOT EXISTS view_once boolean NOT NULL DEFAULT false;
ALTER TABLE messages ADD COLUMN IF NOT EXISTS view_once_opened_at timestamptz;
ALTER TABLE messages ADD COLUMN IF NOT EXISTS view_once_opened_by uuid REFERENCES users(id) ON DELETE SET NULL;
ALTER TABLE messages ADD COLUMN IF NOT EXISTS view_once_access_key_hash bytea;
ALTER TABLE messages ADD COLUMN IF NOT EXISTS view_once_access_expires_at timestamptz;
CREATE INDEX IF NOT EXISTS messages_view_once_expiry_idx
  ON messages(view_once_access_expires_at) WHERE view_once = true AND view_once_opened_at IS NOT NULL;

-- Pin/archive Story collections are private to each saving viewer.
CREATE TABLE IF NOT EXISTS story_collections (
  owner_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  story_id uuid NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
  collection_kind varchar(10) NOT NULL CHECK (collection_kind IN ('pin','archive')),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(owner_id, story_id, collection_kind)
);
CREATE INDEX IF NOT EXISTS story_collections_owner_idx
  ON story_collections(owner_id, collection_kind, created_at DESC);

-- Group polls and votes. A user has one active vote per poll and may change it.
CREATE TABLE IF NOT EXISTS group_polls (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id uuid NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
  creator_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question varchar(180) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS group_polls_group_idx ON group_polls(group_id, created_at DESC);
CREATE TABLE IF NOT EXISTS group_poll_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  poll_id uuid NOT NULL REFERENCES group_polls(id) ON DELETE CASCADE,
  option_text varchar(80) NOT NULL,
  sort_order smallint NOT NULL DEFAULT 0,
  UNIQUE(poll_id, sort_order), UNIQUE(poll_id, option_text)
);
CREATE TABLE IF NOT EXISTS group_poll_votes (
  poll_id uuid NOT NULL REFERENCES group_polls(id) ON DELETE CASCADE,
  option_id uuid NOT NULL REFERENCES group_poll_options(id) ON DELETE CASCADE,
  voter_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(poll_id, voter_id)
);
CREATE INDEX IF NOT EXISTS group_poll_votes_option_idx ON group_poll_votes(option_id);

-- Channel reactions: one selected emoji per user/post. Users can toggle it off or change it.
CREATE TABLE IF NOT EXISTS channel_post_reactions (
  post_id uuid NOT NULL REFERENCES channel_posts(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  emoji varchar(8) NOT NULL CHECK (emoji IN ('👍','❤️','😂','😮','🎉','🔥')),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(post_id, user_id)
);
CREATE INDEX IF NOT EXISTS channel_post_reactions_post_idx
  ON channel_post_reactions(post_id, emoji);

COMMIT;
