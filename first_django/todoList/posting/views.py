from rest_framework.response import Response
from todoList.posting.serializer import TaskSerializer

from django.shortcuts import render


# @api_view는 decorator의 역할
# GET으로 받을 시와 POST 형식으로 받을 시에 따라 어떻게 작동할지를 나눠줌
@api_view(['POST'])
def addTask(request):
    if request.method == 'POST':
        serializer = TaskSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=200)
        else:
            print(serializer.errors)
    return Response(serializer.errors,status=400)