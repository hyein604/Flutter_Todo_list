from django.db import models

class Task(models.Model):
    #AutoField : 자동으로 수가 올라가는 필드
    #primary_key=True :주 키를 의미하며 해당 데이터 테이블에 있어서 중복을 허용하지 않음
    #isComplete BooleanField : Task가 완료되어 있는지를 보기 위함
    id = models.AutoField(primary_key=True)
    work = models.CharField(max_length=400,default='null')
    isComplete = models.BooleanField(default=False)