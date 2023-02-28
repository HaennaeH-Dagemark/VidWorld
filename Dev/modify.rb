def findmiddle(array_input)
  i = 0
  while array_input[i] != nil
    i += 1
  end
  puts array_input[(i / 2) + 0.5]
end

pasta = [3, 8, 9, 1, 20, 3.5, 7]
findmiddle(pasta)
