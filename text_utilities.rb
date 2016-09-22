def pluralize(num, word)
  num == 1 ? "#{num} #{word}" : "#{num} #{word}s"
end

def truncate_if_greater_than_12(string)
  string.length > 12 ? "#{string[0, 12]}..." : string
end
