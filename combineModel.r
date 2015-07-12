library(readr)
setwd("E:/Anlytics Vidya - Hackathon")

b1 = read_csv("rLM.csv") 

b4  = read_csv("pythLM.csv") 

result = read_csv("sample_submission.csv")


result$predictions = round((b1$prediction*0.6)+(b4$prediction*0.4),0)


write.csv(result,"CombiModel.csv",row.names=F)   
#model to finally submit
