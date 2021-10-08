local source = {}
local bib = require 'cmp-pandoc-citations.bibliography'

source.new = function()
	return setmetatable({}, {__index = source})
end

source.is_available = function()
	return vim.o.filetype == 'pandoc' or vim.o.filetype == 'markdown'
end

source.get_trigger_characters = function()
	return {'@'}
end

source.complete = function(self, request, callback)
  local references = bib.get_bibliography()

  if references then
    self.items = references
    callback(self.items)
  end

end

require('cmp').register_source(source.new())
