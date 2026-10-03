-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- lua/config/autocmds.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.formatoptions:append("t")
  end,
  desc = "Hard wrap prose filetypes at 80 cols",
})

local gitmojis = {
  { code = ":art:", desc = "Improve structure / format of the code" },
  { code = ":zap:", desc = "Improve performance" },
  { code = ":fire:", desc = "Remove code or files" },
  { code = ":bug:", desc = "Fix a bug" },
  { code = ":ambulance:", desc = "Critical hotfix" },
  { code = ":sparkles:", desc = "Introduce new features" },
  { code = ":memo:", desc = "Add or update documentation" },
  { code = ":rocket:", desc = "Deploy stuff" },
  { code = ":lipstick:", desc = "Add or update the UI and style files" },
  { code = ":tada:", desc = "Begin a project" },
  { code = ":white_check_mark:", desc = "Add, update, or pass tests" },
  { code = ":lock:", desc = "Fix security or privacy issues" },
  { code = ":closed_lock_with_key:", desc = "Add or update secrets" },
  { code = ":bookmark:", desc = "Release / Version tags" },
  { code = ":rotating_light:", desc = "Fix compiler / linter warnings" },
  { code = ":construction:", desc = "Work in progress" },
  { code = ":green_heart:", desc = "Fix CI build" },
  { code = ":arrow_down:", desc = "Downgrade dependencies" },
  { code = ":arrow_up:", desc = "Upgrade dependencies" },
  { code = ":pushpin:", desc = "Pin dependencies to specific versions" },
  { code = ":construction_worker:", desc = "Add or update CI build system" },
  { code = ":chart_with_upwards_trend:", desc = "Add or update analytics or track code" },
  { code = ":recycle:", desc = "Refactor code" },
  { code = ":heavy_plus_sign:", desc = "Add a dependency" },
  { code = ":heavy_minus_sign:", desc = "Remove a dependency" },
  { code = ":wrench:", desc = "Add or update configuration files" },
  { code = ":hammer:", desc = "Add or update development scripts" },
  { code = ":globe_with_meridians:", desc = "Internationalization and localization" },
  { code = ":pencil2:", desc = "Fix typos" },
  { code = ":poop:", desc = "Write bad code that needs to be improved" },
  { code = ":rewind:", desc = "Revert changes" },
  { code = ":twisted_rightwards_arrows:", desc = "Merge branches" },
  { code = ":package:", desc = "Add or update compiled files or packages" },
  { code = ":alien:", desc = "Update code due to external API changes" },
  { code = ":truck:", desc = "Move or rename resources (files, paths, routes)" },
  { code = ":page_facing_up:", desc = "Add or update license" },
  { code = ":boom:", desc = "Introduce breaking changes" },
  { code = ":bento:", desc = "Add or update assets" },
  { code = ":wheelchair:", desc = "Improve accessibility" },
  { code = ":bulb:", desc = "Add or update comments in source code" },
  { code = ":beers:", desc = "Write code drunkenly" },
  { code = ":speech_balloon:", desc = "Add or update text and literals" },
  { code = ":card_file_box:", desc = "Perform database related changes" },
  { code = ":loud_sound:", desc = "Add or update logs" },
  { code = ":mute:", desc = "Remove logs" },
  { code = ":busts_in_silhouette:", desc = "Add or update contributor(s)" },
  { code = ":children_crossing:", desc = "Improve user experience / usability" },
  { code = ":building_construction:", desc = "Make architectural changes" },
  { code = ":iphone:", desc = "Work on responsive design" },
  { code = ":clown_face:", desc = "Mock things" },
  { code = ":egg:", desc = "Add or update an easter egg" },
  { code = ":see_no_evil:", desc = "Add or update a .gitignore file" },
  { code = ":camera_flash:", desc = "Add or update snapshots" },
  { code = ":alembic:", desc = "Perform experiments" },
  { code = ":mag:", desc = "Improve SEO" },
  { code = ":label:", desc = "Add or update types" },
  { code = ":seedling:", desc = "Add or update seed files" },
  { code = ":triangular_flag_on_post:", desc = "Add, update, or remove feature flags" },
  { code = ":goal_net:", desc = "Catch errors" },
  { code = ":dizzy:", desc = "Add or update animations and transitions" },
  { code = ":wastebasket:", desc = "Deprecate code that needs to be cleaned up" },
  { code = ":passport_control:", desc = "Work on authorization, roles, permissions" },
  { code = ":adhesive_bandage:", desc = "Simple fix for a non-critical issue" },
  { code = ":monocle_face:", desc = "Data exploration / inspection" },
  { code = ":coffin:", desc = "Remove dead code" },
  { code = ":test_tube:", desc = "Add a failing test" },
  { code = ":necktie:", desc = "Add or update business logic" },
  { code = ":stethoscope:", desc = "Add or update healthcheck" },
  { code = ":bricks:", desc = "Infrastructure related changes" },
  { code = ":technologist:", desc = "Improve developer experience" },
  { code = ":money_with_wings:", desc = "Add sponsorships or money-related infrastructure" },
  { code = ":thread:", desc = "Add or update code related to multithreading / concurrency" },
  { code = ":safety_vest:", desc = "Add or update code related to validation" },
}

local function pick_gitmoji()
  vim.ui.select(gitmojis, {
    prompt = "Gitmoji",
    format_item = function(item)
      return string.format("%-24s %s", item.code, item.desc)
    end,
  }, function(choice)
    if choice then
      vim.cmd("stopinsert")
      vim.api.nvim_put({ choice.code }, "c", true, true)
      vim.cmd("startinsert!")
    end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function(args)
    vim.keymap.set({ "n", "i" }, "<C-g>e", pick_gitmoji, { buffer = args.buf, desc = "Insert gitmoji code" })
  end,
})
