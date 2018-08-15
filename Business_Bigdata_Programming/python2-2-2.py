queue = [1, 2, 3, 4, 5]

def is_empty(queue):
	return bool(len(queue))
print(is_empty(queue))

def enqueue(queue, item):
	queue.append(item)
enqueue(queue, 6)
print(queue)

def dequeue(queue):
	temp = queue[0]
	for i in range(len(queue)-1):
		queue[i] = queue[i+1]
	queue.pop()
	return temp

dequeue(queue)
print(queue)

def get_size(queue):
	return len(queue)

print(get_size(queue))