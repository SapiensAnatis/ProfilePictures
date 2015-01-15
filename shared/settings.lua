GlobalSettings = {}

GlobalSettings.Timeout = 5 -- The number of seconds after which the script should give up trying to ping Steam servers and instead use the default avatar
GlobalSettings.APIKey = "" -- Since under the ToS of the API agreement I'm not allowed to share an API key (and I'm sure my requests would go over 1000 per day if I shared it anyway), you must enter yours here. Get one @ http://steamcommunity.com/dev/apikey


GlobalSettings.StoreB64OnServer = true
-- This setting controls whether base64 (strings that take up a lot of space) should be stored on the server. For servers with lots of players and where scripts use large avatars often, this option isn't recommended.
-- However, if the option is selected, it can result in faster load times after the server has been up for a while

GlobalSettings.StoreB64OnClient = true

-- Whether or not to store images gained from requests on the client (this is used with the scoreboard script). FPS drops may be a result of this; load times will be quicker though

GlobalSettings.GiveAllDataToPlayerOnJoin = false

-- Whether or not to send the base64 images of every player on the server to the client on join. While it may reduce on performance loss on connection (both on server and client) for the joining player, the playerlist will not be required to load any images and will display them all instantly.
