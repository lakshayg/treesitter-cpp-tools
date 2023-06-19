local util = require("utility")

local M = {}

M.stl = {
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

util.set_add(M.stl.headers.iostream, M.stl.headers.ios)
util.set_add(M.stl.headers.iostream, M.stl.headers.streambuf)
util.set_add(M.stl.headers.iostream, M.stl.headers.istream)
util.set_add(M.stl.headers.iostream, M.stl.headers.ostream)

return M