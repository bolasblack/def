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
  def obj, [context, varname]
  ###
  def = (obj, args...) ->
    throw new Error 'must pass in an object' unless obj?
    return extendObj(obj) unless args.length
    fn = if args[0] is "judge" \
      then regJudge \
      else if args[0] in (k for own k of typeJudge) \
      then regExtend(args[0]) \
      else
        extendObj obj
        bindToContext args[0]
    fn obj, args[1]
    obj

  def.isType = isType = (type, obj) ->
    typeJudge[type] obj

  def._typeJudge = typeJudge = {}
  regJudge = (judge, className) ->
    typeJudge[className] = judge

  def._extend = extend = {}
  regExtend = (className) ->
    (prop, propName) ->
      extend[className] or= {}
      extend[className][propName] or= prop

  bindToContext = (context) ->
    (obj, varname) ->
      context[varname] = obj

  extendObj = (obj) ->
    for className, propData of extend when isType className, obj
      for propName, prop of propData
        obj[propName] = prop
      obj.defed = true
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
