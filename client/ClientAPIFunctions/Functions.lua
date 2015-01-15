function Player:GetAvatar(size)
  local img = Image.Create(AssetLocation.Base64, self:GetValue("avatar_" .. size:gsub(1, 1)))
  return img
end