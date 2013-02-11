# Module systems magic dance
((definition) ->
  # RequireJS
  if typeof define is "function"
    define definition
  # YUI3
  else if typeof YUI is "function"
    YUI.add "", definition
  # CommonJS and <script>
  else
    definition()
)(->
  ###
  def prop, className, propName
  def fn, "judge", className
  def obj [, context, varname] [, tmpExtraMap]
  ###
  def = (obj, args...) ->
    throw new Error 'must pass in an object' unless obj?
    # def obj [, tmpExtraMap]
    return extendObj(obj, args[0]) if args.length in [0, 1]
    fn = if args[0] is "judge" \
      # def fn, "judge", className
      then regJudge \
      else if args[0] in (k for own k of typeJudge) \
      # def prop, className, propName
      then regExtend(args[0]) \
      # def obj, context, varname [, tmpExtraMap]
      else
        extendObj obj, args[3]
        bindToContext args[0]
    fn obj, args[1]
    obj

  def.isType = isType = (type, obj) ->
    typeJudge[type] obj

  def._typeJudge = typeJudge = {}
  regJudge = (judge, className) ->
    typeJudge[className] = judge

  def._extension = extension = {}
  regExtend = (className) ->
    (prop, propName) ->
      extension[className] or= {}
      extension[className][propName] or= prop

  bindToContext = (context) ->
    (obj, varname) ->
      context[varname] = obj

  extend = (obj, extension) ->
    for className, propData of extension when isType className, obj
      obj.defed = true
      obj[propName] = prop for propName, prop of propData
    obj

  extendObj = (obj, extraMap) ->
    extend obj, extension
    extend obj, extraMap if extraMap
    obj

  olddef = @def
  @def = def

  # register toolkit.coffee judge
  classes = "PlainObject Boolean Array Function String Number Date RegExp".split " "
  for className in classes.concat ["Node", "XMLDoc", "Element"]
    do (className) ->
      def (obj) ->
        G["is#{className}"] obj
      , "judge", className

  if _?.chain?()
    underscoreArrayFns = "first initial last rest compact flatten without union intersection difference uniq zip object range".split " "
    for method in underscoreArrayFns
      def _[method], "Array", method
)
