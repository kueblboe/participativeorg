jQuery.fn.highlightTextFragment = (pattern, className) ->
  # assume very LOOSELY pattern is regexp if not string
  innerHighlight = (node, pattern, className) ->
    skip = 0
    if node.nodeType is 3 # 3 - Text node
      pos = node.data.search(regex)
      if pos >= 0 and node.data.length > 0 # .* matching "" causes infinite loop
        match = node.data.match(regex) # get the match(es), but we would only handle the 1st one, hence /g is not recommended
        spanNode = document.createElement("span")
        spanNode.className = className # set css
        middleBit = node.splitText(pos) # split to 2 nodes, node contains the pre-pos text, middleBit has the post-pos
        endBit = middleBit.splitText(match[0].length) # similarly split middleBit to 2 nodes
        middleClone = middleBit.cloneNode(true)
        spanNode.appendChild middleClone
        
        # parentNode ie. node, now has 3 nodes by 2 splitText()s, replace the middle with the highlighted spanNode:
        middleBit.parentNode.replaceChild spanNode, middleBit
        skip = 1 # skip this middleBit, but still need to check endBit
    else if node.nodeType is 1 and node.childNodes and not /(script|style)/i.test(node.tagName) # 1 - Element node
      i = 0 # highlight all children

      while i < node.childNodes.length
        i += innerHighlight(node.childNodes[i], pattern, className) # skip highlighted ones
        i++
    skip
  regex = (if typeof (pattern) is "string" then new RegExp(pattern, "i") else pattern)
  @each -> innerHighlight this, pattern, className