Todos = SC.Application.create()

Todos.Todo = SC.Object.extend
  title: null
  isDone: false

Todos.CreateTodoView = SC.TextField.extend
  insertNewline: ->
    value = (@get 'value')
    if (value)
      Todos.todoListController.createTodo(value)
      (@set 'value', '')

Todos.MarkDoneView = SC.Checkbox.extend
  titleBinding: '.parentView.content.title'
  valueBinding: '.parentView.content.isDone'

Todos.StatsView = SC.TemplateView.extend
  remainingBinding: 'Todos.todoListController.remaining'
  displayRemaining: ( ->
    remaining = (@get 'remaining')
    "#{remaining} #{((remaining == 1) ? " item" : " items")}"
  ).property('remaining')

# Main function. Ready
SC.ready ->
  Todos.mainPane = SC.TemplatePane.append
    layerId: 'todos'
    templateName: 'todos'
# End of main function.

Todos.todoListController = SC.ArrayController.create
  content: []
  createTodo: (title) ->
    todo = Todos.Todo.create {title}
    (@pushObject todo)

  remaining: ( ->
    @filterProperty('isDone', false).get('length')
  ).property('@each.isDone')
  
  clearCompletedTodos: ->
    @filterProperty('isDone', true).forEach(@removeObject, this)

  allAreDone: ( (key, value) ->
    if (value != undefined)
      @setEach('isDone', true)
      value
    else
      @get('length') && @everyProperty('isDone', true)
  ).property('@each.isDone')

window.Todos = Todos