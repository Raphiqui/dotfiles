--[[
  Keep an eye over this reddit post https://www.reddit.com/r/neovim/comments/1k7ixe7/latest_update_has_lazyvim_complaining_about/
  I'm still not sure what happened and why it broke but this is the way to rollback nui plugin.
  When solved just get rid of this or similar
--]]
return {
  {
    "MunifTanjim/nui.nvim",
    commit = "8d3bce9764e627b62b07424e0df77f680d47ffdb",
  },
}
