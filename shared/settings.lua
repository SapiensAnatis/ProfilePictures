GlobalSettings = {}

GlobalSettings.Timeout = 5 -- The number of seconds after which the script should give up trying to ping Steam servers and instead use the default avatar
GlobalSettings.APIKey = "075AB53DC16E31E66B5D10A61D3766CC" -- Since under the ToS of the API agreement I'm not allowed to share an API key (and I'm sure my requests would go over 1000 per day if I shared it anyway), you must enter yours here. Get one @ http://steamcommunity.com/dev/apikey
GlobalSettings.AvatarSize = "medium" -- Depending on your use for the script, you may choose to select an avatar size here. Large is 184x184, medium 64x64 and small is 32x32. Note that bigger sizes will cause longer loading times when players join.
-- Possible values: small, medium, full or large.

GlobalSettings.StoreB64OnServer = true

-- This setting controls whether base64 (strings that take up a lot of space) should be stored on the server. For servers with lots of players and where scripts use large avatars often, this option is recommended.