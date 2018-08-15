def is_empty(stack):
	return bool(len(stack))
def push(stack, item):
	stack.append(item)
def pop(stack):
	return stack.pop()

	
def top_value(stack):
	return stack[len]