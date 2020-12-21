library(rvest)
library(jsonlite)

url = "http://www.koeri.boun.edu.tr/scripts/lst7.asp"
web_page <- read_html(url)

web_page <- read_html(url)
pre_text <- web_page %>%
html_node("pre") %>%
html_text()
pre_text #check for text

#first rows, then columns
pre_text2 = strsplit(pre_text, "\r\n")
pre_text2 = unlist(pre_text2)
pre_text3 = strsplit(pre_text2, "  ")

pre_text3 <- pre_text3[-c(1:7)] #clean first rows
pre_text3 <- pre_text3[-501] #clean last row

#clean all "" s
df <- lapply(pre_text3, function(z){ z[!is.na(z) & z != ""]}) 

#create a list, then dataframe
df = as.list(df)
df <- do.call(rbind.data.frame, df)

#change column names
names(df)[1] <- "TimeStamp"
names(df)[2] <- "Enlem(N)"
names(df)[3] <- "Boylam(E)"
names(df)[4] <- "Derinlik(km)"
names(df)[5] <- "MD"
names(df)[6] <- "ML"
names(df)[7] <- "Mw"
names(df)[8] <- "Yer"
names(df)[9] <- "Çözüm Niteligi"

#remove repeated timestamp column
df <- df[,-10]

#write dataframe to a csv
write.csv(df, "C:\\Users\\Analythinx\\Desktop\\deprem-data\\Deprem_Data.csv")

#create and write JSON file
dfJSON <- toJSON(df)
cat(dfJSON) #check
write(dfJSON, "Deprem_Data.JSON")