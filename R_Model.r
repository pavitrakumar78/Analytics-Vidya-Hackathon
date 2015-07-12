setwd("E:/Anlytics Vidya - Hackathon")
library(MASS)
library(mlbench)
library(caret)
#reading the files

train=read.csv("train.csv")
test=read.csv("test.csv")
id = test$id

train$Day_of_publishing = as.factor(train$Day_of_publishing)
train$Day_of_publishing = as.integer(train$Day_of_publishing)

train$Category_article = as.factor(train$Category_article)
train$Category_article = as.integer(train$Category_article)

test$Day_of_publishing = as.factor(test$Day_of_publishing)
test$Day_of_publishing = as.integer(test$Day_of_publishing)

test$Category_article = as.factor(test$Category_article)
test$Category_article = as.integer(test$Category_article)


test$shares = NULL

fit<-lm(shares~.,data=train) 

step <- stepAIC(fit, direction="both")

#below feature list obtained from stepAIC 

fit<-lm(shares ~ id + n_tokens_title + n_tokens_content + n_unique_tokens + 
          n_non_stop_words + num_hrefs + num_self_hrefs + num_imgs + 
          average_token_length + num_keywords + Category_article + 
          kw_min_min + kw_min_max + kw_min_avg + kw_max_avg + kw_avg_avg + 
          self_reference_min_shares + self_reference_max_shares + self_reference_avg_sharess + 
          Day_of_publishing + LDA_02 + LDA_03 + LDA_04 + global_subjectivity + 
          global_rate_positive_words + rate_positive_words + avg_positive_polarity + 
          avg_negative_polarity + title_sentiment_polarity + abs_title_subjectivity,data=train) #5573.42 

pred= predict(fit,test)
submit<-data.frame(id=id,predictions=pred)
write.csv(submit,file="rLM.csv",row.names=FALSE)
