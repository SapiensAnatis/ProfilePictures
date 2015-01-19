AvatarUtility
=================

About
---------

**Warning**: This script is not tested, nor designed for servers with large playercounts >20.

That said, if you're still interested, this script allows you to get avatars from the Steam database and incorporate them into your scripts.

Usage:
----------

```lua
-- Value: avatar_<s, m, or l>
-- Returns: string: base64 of player avatar in the given size
-- Availability: Server and client side
-- Example usage:

local smallAvatar = LocalPlayer:GetValue("avatar_s")
local medAvatar = LocalPlayer:GetValue("avatar_m")
local largeAvatar = LocalPlayer:GetValue("avatar_l")

```

This returns the Base64 for the player's avatar in the given size, where you can draw it or do whatever.

**By default, the last two lines of this example will return nil. To fix this, change the settings `GlobalSettings.GetAvatarMedOnJoin = false` and `GlobalSettings.GetAvatarLargeOnJoin = false` to true; by default only the small one is true. If you don't need to use these sizes, feel free not to. However, note that the scoreboard requires the small setting to be on.** 

Available settings
-------------------

* Timeout: this is how long the script will await a response from the Steam API. Use to avoid stalling the script/server.
* APIKey: this is a necessary setting you have to use to get profile pictures. It's a unique key that you can request [here](steamcommunity.com/dev/apikey).
* Avatar sizes to get on ClientModuleLoad/join: these dictate what sizes should be requested when the player joins the server. The small option is necessary for the given scoreboard to work.

Stats
---------

From my brief testing, given good conditions and a good Internet connection, it will complete the above usage example in 2.3 to 4.5 seconds.
This may deter you, given that you may now think that for a server of ~200 players, if you reload the module, it could take up to 7 minutes for it to load. 
This is only the case for server restarts. The script makes use of Player:SetNetworkValue() which is persistent through reloads. If you reload the module, only new players will have their data requested.

If Steam is down, it will take 5 seconds (the default timeout, this is configurable in the settings) and then give up, using the default "?" avatar for the given player instead.


Credit
---------
Huge credit to three members of the JC-MP community: Jman100, SK83RJOSH and Trix, who helped me with the external libraries, which were giving me so much trouble beforehand.

Misc
--------
The script currently is not optimized for large servers. Use at your own risk.

License
---------
The MIT License (MIT)

Copyright (c) 2015 revalationist/Lord Noob

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

