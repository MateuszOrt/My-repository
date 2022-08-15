#Tematem projektu jest przewidaywanie pojemności płuc ludzi powyżej 10 roku życia.
# Do przewidywania użyte zostaną cechy: Wiek,wzrost,czy dana osoba pali czy też nie,płeć,cesarskie cięcie tak lub nie
#Modele będe wykonane przy pomocy regresji liniowej oraz sieci neuronowych
dane1<-LungCapData
dane1$Smoke<- as.integer(factor(dane1$Smoke))-1
dane1$Gender<- as.integer(factor(dane1$Gender))-1
dane1$Caesarean<- as.integer(factor(dane1$Caesarean))-1
dane1
dane <- subset(dane1, Age>10) 
dane
nrow(dane)
uczenie<-dane[1:100,]
rozpoznanie<-dane[101:nrow(dane),]

attach(uczenie)

#Korelacje
cor(Age,Height,method="pearson") # 0.782136
cor(Smoke,Gender,method="pearson")# -0.1734728
cor(Age,Smoke,method="pearson")# 0.005597343

cor(Age,Height,method="kendall")#0.5978373
cor(Age,Height,method="spearman")#0.7594788
#Testy na korelacje wykazują dość  duże skorelowanie. wzrost jest czynnikiem mocno zdeterminowanym przez wiek(tym bardziej w tym przypadku kiedy wiek ludzi
#rozpoczyna się od 10lat) natomiast korelacja będzie zanikać przy porównywaniu ludzi coraz starszych

model<-lm(LungCap~Age+Height+Smoke+Gender+Caesarean)
summary(model)
#po stworzeniu podsumowania modelu okazuje się, że cechy Caesarean i Gender nie są tak istotne
model1<-lm(LungCap~Age+Height+Smoke+Gender)
summary(model1)
model2<-lm(LungCap~Age+Height+Smoke)
summary(model2)
#po usunięciu cechy gender wzrósł poziom istotności cechy smoke
# porównam działanie wszystkich trzech mdoeli podanych wyżej

#Rozkłady
shapiro.test(dane$Age)
shapiro.test(dane$Height)

PRED=predict(model,rozpoznanie)
sum(abs(PRED-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(PRED)#algorytm myli się średnio 0 10.16%

PRED1=predict(model1,rozpoznanie)
sum(abs(PRED1-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(PRED1)#10.14%

PRED2=predict(model2,rozpoznanie)
sum(abs(PRED2-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(PRED2)#10.21%

#Najmneiejszy bład wyszedł dla modelu który nie uwzględniał jedynie cechy Caesarean
###########################################################################################################################

library(neuralnet)
nn1=neuralnet(LungCap~Age+Height+Smoke+Gender+Caesarean,data=uczenie,hidden=2,threshold = 0.05,linear.output = TRUE,stepmax=1e7)

nn3=neuralnet(LungCap~Age+Height+Smoke+Gender+Caesarean,data=uczenie,hidden=c(3,2),threshold = 0.05,linear.output = TRUE,stepmax=1e7)

nn5=neuralnet(LungCap~Age+Height+Smoke+Gender+Caesarean,data=uczenie,hidden=c(5),threshold = 0.05,linear.output = TRUE,stepmax=1e7)
pred1=predict(nn1,rozpoznanie)
sum(abs(pred1-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(pred1)#18.41%
pred3=predict(nn3,rozpoznanie)
sum(abs(pred3-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(pred3)#18.41%
pred5=predict(nn5,rozpoznanie)
sum(abs(pred5-rozpoznanie$LungCap)/rozpoznanie$LungCap)/length(pred5)#11.39%
pred5
# W mojej symulacji najmniejszy bład wyszedł dla sieci z 5 neuronami (wyniki błedów które mi wyszły zapisane obok komend)
# Podsumowując oba modele przewidują pojemność płuc na dość dobrym poziomie suteczności. Można powiedzieć że  metoda regresji liniowej poradziła sobie 
#lepiej jeżeli chodzi o sumę błędów wszystkich modeli. Natomiast sieć neuronowa z 5 neuronami daje rezultat bardzo zbliżony do modelu regresji