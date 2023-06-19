local M = {}

-- computes the size of the table t
M.table_size = function(t)
   local count = 0
   for _, __ in pairs(t) do
      count = count + 1
   end
   return count
end

-- add elements of set b into set a
M.set_add = function(a, b)
   for k, _ in pairs(b) do
      a[k] = true
   end
end

-- removes elements of set b from set a
M.set_minus = function(a, b)
   for k, _ in pairs(b) do
      a[k] = nil
   end
end

-- returns the intersection of sets a and b
M.set_intersection = function(a, b)
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

return M
