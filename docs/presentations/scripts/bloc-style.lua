function Header(el)
  for _, c in ipairs(el.classes) do
    if c == "bloc" then
      el.attributes["custom-style"] = "Bloc"
      break
    end
  end
  return el
end
