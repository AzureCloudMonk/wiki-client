# The lineup represents a sequence of pages with possible
# duplication. We maintain the lineup in parallel with
# the DOM list of .page elements. Eventually lineup will
# play a more central role managing calculations and
# display updates.

random = require './random'

pageByKey = {}
keyByIndex = []


# Basic manipulations that correspond to typical user activity

addPage = (pageObject) ->
  key = random.randomBytes 4
  pageByKey[key] = pageObject
  keyByIndex.push key
  return key

removeKey = (key) ->
  return null unless key in keyByIndex
  keyByIndex = keyByIndex.filter (each) -> key != each
  delete pageByKey[key]
  key

removeAllAfterKey = (key) ->
  result = []
  return result unless key in keyByIndex
  while keyByIndex[keyByIndex.length-1] != key
    unwanted = keyByIndex.pop()
    result.unshift unwanted
    delete pageByKey[unwanted]
  result

atKey = (key) ->
  pageByKey[key]


# Debug access to internal state used by unit tests.

debugKeys = ->
  keyByIndex

debugReset = ->
  pageByKey = {}
  keyByIndex = []


# Debug self-check which corrects misalignments until we get it right

debugSelfCheck = (keys) ->
  return if (have = "#{keyByIndex}") is (want = "#{keys}")
  console.log 'The lineup is out of sync with the dom.'
  console.log ".pages:", keys
  console.log "lineup:", keyByIndex
  return unless "#{Object.keys(keyByIndex).sort()}" is "#{Object.keys(keys).sort()}"
  console.log 'It looks like an ordering problem we can fix.'
  keysByIndex = keys


# Select a few crumbs from the lineup that will take us
# close to welcome-visitors on a (possibly) remote site.

crumbs = (key, location) ->
  page = pageByKey[key]
  host = page.getRemoteSite(location)
  result = ['view', slug = page.getSlug()]
  result.unshift('view', 'welcome-visitors') unless slug == 'welcome-visitors'
  result.unshift(host)
  result


module.exports = {addPage, removeKey, removeAllAfterKey, atKey, debugKeys, debugReset, crumbs, debugSelfCheck}