describe "the def lib", ->
  should = chai.should()

  beforeEach ->
  afterEach ->

  it "should handler one or three argument", ->
    def([]).should.have.property 'defed'
    def [], this, 'array'
    this.should.to.have.property 'array'
    @array.should.to.have.property 'defed'

  it "should judge object type", ->
    typeFixtrue = [
      {type: "Array", value: []}
      {type: "PlainObject", value: {}}
      {type: "Boolean", value: true}
      {type: "Function", value: ->}
      {type: "String", value: "some string"}
      {type: "Number", value: 3}
      {type: "Date", value: new Date}
      {type: "RegExp", value: /.*/}
      {type: "Node", value: document}
      {type: "Element", value: document.createElement "p"}
      # TODO: test XMLDoc
      # {type: "XMLDoc", value: XMLDocument}
    ]

    for {type, value} in typeFixtrue
      def.isType(type, value).should.be.true

  it "should register judge", ->
    def (obj) ->
      obj is "testcase"
    , "judge", "testcase"

    def.isType("testcase", "testcase").should.be.true
    def.isType("testcase", "estcase").should.be.false

  it "should can be overwrite registered judge", ->
    def (obj) ->
      obj is "estcase"
    , "judge", "testcase"

    def.isType("testcase", "testcase").should.be.false
    def.isType("testcase", "estcase").should.be.true

  it "should extend pass in object by prototype"
  it "should extend pass in object with 4th argument of `def`"
