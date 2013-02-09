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
  def property, "extra"
  def fn, "judge", className
  def obj, [context, varname]
  ###
  def = (obj, args...) ->
    throw new Error 'must pass in an object' unless obj?
    obj.defed = true
    # TODO: extend all method
    if args.length
      fn = switch args[0]
        when "judge" then regJudge
        when "extra" then regExtend
        else bindToContext args[0]
      fn obj, args[1]
    obj

  def.isType = (type, obj) ->
    typeJudge[type] obj

  def._typeJudge = typeJudge = {}
  regJudge = (judge, className) ->
    typeJudge[className] = judge

  def._extend = extend = {}
  regExtend = (value, className) ->
    extend[className] = value

  bindToContext = (context) ->
    (obj, varname) ->
      context[varname] = obj

  olddef = @def
  @def = def

  # register toolkit.coffee judge
  classes = "PlainObject Boolean Array Function String Number Date RegExp".split " "
  for className in classes.concat ["Node", "XMLDoc", "Element"]
    do (className) ->
      def (obj) ->
        G["is#{className}"] obj
      , "judge", className
)
