AvatarUtility
=================

About
---------

**Warning**: This script is in heavy beta right now. Updates are coming which will make the script more efficient and easier to use.

That said, if you're still interested, this script allows you to get avatars from the Steam database and incorporate them into your scripts.

Usage:
----------

```lua
-- Function: Player:GetAvatar(string: size)
-- Returns: string: base64 of player avatar in the given size
-- Availability: Server-side only
-- Example usage:

function PlayerJoin(args)
	local Base64 = args.player:GetAvatar("medium") -- size can be medium, small or large; if something else or nothing (e.g "12353467rehb\sdfh") is used, it will default to small.
	Network:Send("DrawThis", Base64)
end

Events:Subscribe("PlayerJoin", PlayerJoin)
```

This sends the Base64 for the player's avatar to said player, where you can draw it or do whatever.

Stats
---------

From my brief testing, given good conditions and a good Internet connection, it will complete the above usage example in 0.8 to 1.3 seconds.
If Steam is down, it will take 30 seconds before giving up and unloading the module.
Note: Steam status checking is planned in a later release

Credit
---------
Huge credit to three members of the JC-MP community: Jman100, SK83RJOSH and Trix, who helped me with the external libraries, which were giving me so much trouble beforehand.

Misc
--------
The script currently is not optimized for large servers. Use at your own risk.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
