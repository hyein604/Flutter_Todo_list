from rest_framework import serializers
from .models import Task

#사용할 serializer의 model은 Task, 직렬화해줄 fields들은 id, work, isComplete이다.
class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = ('id','work','isComplete')