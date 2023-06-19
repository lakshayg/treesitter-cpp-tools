local M = {
   stl = {
      ignore = {
         "get", "tuple_size",              -- array, tuple, variant, pair
         "begin", "cbegin", "end", "cend", -- generally available in container headers
         "swap",                           -- algorithm, utility, string_view
         "hash",                           -- we're only interested in fwd decl
      },
      headers = {
         -- concepts = {},
         -- coroutine = {},
         -- any = {},
         bitset = {
            bitset = true,
         },
         chrono = {
            ["chrono::system_clock"] = true,
            ["chrono::milliseconds"] = true,
            ["chrono::seconds"] = true,
         },
         -- compare = {},
         -- csetjmp = {},
         -- csignal = {},
         -- cstdarg = {},
         -- cstddef = {},
         cstdlib = {
            rand = true,
            srand = true,
            atof = true,
            atoi = true,
            atol = true,
            atoll = true,
            strtol = true,
            strtoll = true,
            strtoul = true,
            strtoull = true,
            strtof = true,
            strtod = true,
            strtold = true,
            system = true,
         },
         -- ctime = {},
         -- expected = {},
         -- functional = {},
         -- initializer_list = {},
         optional = {
            optional = true,
            nullopt = true,
         },
         -- source_location = {},
         tuple = {
            tie = true,
            tuple = true,
            make_tuple = true,
            forward_as_tuple = true,
         },
         -- type_traits = {},
         -- typeindex = {},
         -- typeinfo = {},
         utility = {
            pair = true,
            move = true,
         },
         -- variant = {},
         -- version = {},
         memory = {
            make_unique = true,
            make_shared = true,
            unique_ptr = true,
            shared_ptr = true,
         },
         -- memory_resource = {},
         -- new = {},
         -- scoped_allocator = {},
         -- cfloat = {},
         -- cinttypes = {},
         -- climits = {},
         cstdint = {
            int8_t = true,
            int16_t = true,
            int32_t = true,
            int64_t = true,
            int_fast8_t = true,
            int_fast16_t = true,
            int_fast32_t = true,
            int_fast64_t = true,
            int_least8_t = true,
            int_least16_t = true,
            int_least32_t = true,
            int_least64_t = true,
            intmax_t = true,
            intptr_t = true,
            uint8_t = true,
            uint16_t = true,
            uint32_t = true,
            uint64_t = true,
            uint_fast8_t = true,
            uint_fast16_t = true,
            uint_fast32_t = true,
            uint_fast64_t = true,
            uint_least8_t = true,
            uint_least16_t = true,
            uint_least32_t = true,
            uint_least64_t = true,
            uintmax_t = true,
            uintptr_t = true,
         },
         limits = {
            numeric_limits = true,
         },
         -- stdfloat = {},
         -- cassert = {},
         -- cerrno = {},
         exception = {
            exception = true,
            ["exception::exception"] = true,
         },
         -- stacktrace = {},
         stdexcept = {
            runtime_error = true,
         },
         -- system_error = {},
         cctype = {
            tolower = true,
            isspace = true,
            isdigit = true,
            isalpha = true,
         },
         -- charconv = {},
         -- cstring = {},
         -- cuchar = {},
         -- cwchar = {},
         -- cwctype = {},
         -- format = {},
         string = {
            string = true,
         },
         string_view = {
            string_view = true,
         },
         array = {
            array = true,
         },
         -- deque = {},
         -- flat_map = {},
         -- flat_set = {},
         -- forward_list = {},
         -- list = {},
         map = {
            map = true,
         },
         -- mdspan = {},
         -- queue = {},
         set = {
            set = true,
         },
         -- span = {},
         -- stack = {},
         unordered_map = {
            unordered_map = true,
         },
         unordered_set = {
            unordered_set = true,
         },
         vector = {
            vector = true,
         },
         iterator = {
            advance = true,
            distance = true,
         },
         -- generator = {},
         ranges = {},
         algorithm = {
            max = true,
            min = true,
            clamp = true,
            partition = true,
            remove_if = true,
            find_if = true,
            ["ranges::copy_if"] = true,
         },
         execution = {},
         bit = {},
         -- cfenv = {},
         -- cmath = {},
         -- complex = {},
         -- numbers = {},
         numeric = {
            accumulate = true,
         },
         -- random = {},
         -- ratio = {},
         -- valarray = {},
         -- clocale = {},
         -- locale = {},
         -- cstdio = {},
         -- fstream = {},
         iomanip = {
            setw = true,
         },
         ios = {
            ["ios_base::failure"] = true,
         },
         iostream = {
            cout = true,
         },
         istream = {},
         ostream = {
            ostream = true,
         },
         -- print = {},
         -- spanstream = {},
         sstream = {
            stringstream = true,
         },
         streambuf = {},
         -- syncstream = {},
         -- filesystem = {},
         -- regex = {},
         -- atomic = {},
         -- barrier = {},
         -- condition_variable = {},
         -- future = {},
         -- latch = {},
         -- mutex = {},
         -- semaphore = {},
         -- shared_mutex = {},
         -- stop_token = {},
         thread = {
            thread = true,
            jthread = true,
            this_thread = true,
         },
      }
   }
}

local function table_size(t)
   local count = 0
   for _, __ in pairs(t) do
      count = count + 1
   end
   return count
end

local function set_add(a, b)
   for k, _ in pairs(b) do
      a[k] = true
   end
end

set_add(M.stl.headers.iostream, M.stl.headers.ios)
set_add(M.stl.headers.iostream, M.stl.headers.streambuf)
set_add(M.stl.headers.iostream, M.stl.headers.istream)
set_add(M.stl.headers.iostream, M.stl.headers.ostream)

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

local function set_intersection(a, b)
   local count = 0
   local intersection = {}
   for k, _ in pairs(a) do
      if b[k] then
         intersection[k] = true
         count = count + 1
      end
   end
   return intersection, count
end

local function set_minus(a, b)
   for k, _ in pairs(b) do
      a[k] = nil
   end
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

function M.most_matching_header(tokens)
   local best_header = ""
   local best_header_size = 0
   local found_tokens = {}
   local max_count = 0

   for header, header_tokens in pairs(M.stl.headers) do
      local header_size = table_size(header_tokens)
      local found, count = set_intersection(tokens, header_tokens)

      if (count > max_count) or (count == max_count and header_size < best_header_size) then
         best_header = header
         best_header_size = header_size
         found_tokens = found
         max_count = count
      end
   end

   return best_header, found_tokens, max_count
end

function M.generate_includes()
   local tokens = get_std_tokens()
   set_minus(tokens, M.stl.ignore)

   local includes = {}
   while true do
      local header, found, count = M.most_matching_header(tokens)
      if count == 0 then
         break
      end

      table.insert(includes, "#include <" .. header .. "> // " .. print_includes(found))
      set_minus(tokens, found)
   end

   table.sort(includes)
   if table_size(tokens) > 0 then
      table.insert(includes, "// Skipped: " .. print_includes(tokens))
   end
   return includes
end

function M.insert_includes()
   local includes = M.generate_includes()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local row = cursor[1] - 1
   vim.api.nvim_buf_set_lines(current_buf, row, row, true, includes)
end

return M
