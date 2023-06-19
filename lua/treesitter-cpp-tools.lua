local util = require("utility")
local db = require("db")

local M = {}

local current_buf  = 0

local function get_node_text(node)
   return vim.treesitter.get_node_text(node, current_buf)
end

local function node2token(node)
   local type = node:type()

   if type == "template_type" then
      return get_node_text(node:field('name')[1])
   elseif type == "template_function" then
      return get_node_text(node:field('name')[1])
   elseif type == "qualified_identifier" then
      local scope = node:field('scope')[1]
      local scope_type = scope:type()
      if scope_type == "namespace_identifier" then
         local namespace = get_node_text(scope)
         local identifier = node2token(node:field('name')[1])
         return namespace .. '::' .. identifier
      elseif scope_type == "template_type" then
         return node2token(scope)
      end
   end

   -- if we don't know how to handle the node type we
   -- return the entire text for that node so that it
   -- can be used for debugging later
   return get_node_text(node)
end

local function print_includes(s)
   local array = {}

   for k, _ in pairs(s) do
      table.insert(array, k)
   end

   -- simplify some names
   for i, val in ipairs(array) do
      if val:find("^chrono::") ~= nil then
         array[i] = val:sub(9, -1)
      end
   end

   table.sort(array)

   local str = ""
   for i, val in ipairs(array) do
      str = str .. val .. ', '
   end

   -- remove the last ", " before returning
   return str:sub(1, -3)
end

local function get_std_tokens()
   local query   = vim.treesitter.query.get('cpp', 'stl_identifiers')
   local parser  = vim.treesitter.get_parser(current_buf, 'cpp')
   local root    = parser:parse()[1]:root()
   local matches = query:iter_matches(root, current_buf)
   local tokens  = {}

   while true do
      local pattern, match = matches()
      if pattern == nil then
         return tokens
      end

      for capture_id, node in pairs(match) do
         local capture_str = query.captures[capture_id]
         if capture_str == "stl_identifier" then
            tokens[node2token(node)] = true
         end
      end
   end
end

local function most_matching_header(tokens)
   local best_header = ""
   local best_header_size = 0
   local found_tokens = {}
   local max_count = 0

   for header, header_tokens in pairs(db.stl.headers) do
      local header_size = util.table_size(header_tokens)
      local found, count = util.set_intersection(tokens, header_tokens)

      if (count > max_count) or (count == max_count and header_size < best_header_size) then
         best_header = header
         best_header_size = header_size
         found_tokens = found
         max_count = count
      end
   end

   return best_header, found_tokens, max_count
end

local function generate_includes()
   local tokens = get_std_tokens()
   util.set_minus(tokens, db.stl.ignore)

   local includes = {}
   while true do
      local header, found, count = most_matching_header(tokens)
      if count == 0 then
         break
      end

      table.insert(includes, "#include <" .. header .. "> // " .. print_includes(found))
      util.set_minus(tokens, found)
   end

   table.sort(includes)
   if util.table_size(tokens) > 0 then
      table.insert(includes, "// Skipped: " .. print_includes(tokens))
   end
   return includes
end

function M.insert_includes()
   local includes = generate_includes()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local row = cursor[1] - 1
   vim.api.nvim_buf_set_lines(current_buf, row, row, true, includes)
end

return M
