// Credits to vishal_jaiswal! Catch him on https://www.reddit.com/user/vishal_jaiswal

library(data.table)
setwd("E:/R-challenges/")
swipe=function(input) {
    text_file=read.delim("enable1.txt",header = FALSE)
    names(text_file)="words"
    text_file=as.data.frame(text_file[nchar(as.character(text_file$words))>=5,])
    names(text_file)="words"
    first=substr(input,1,1)
    end=substr(input,nchar(input),nchar(input))
    text_file$length=nchar(as.character(text_file$words))
    text_file$first=substr(text_file$words,1,1)
    text_file"nd=substr(text_file$words,text_file$length,text_file$length)
    pipeline=text_file[text_file$first==first & text_file"nd==end,]
                       output=list()
    for(i in 1:nrow(pipeline)) {
        check=as.character(pipeline$words[i])
        checklist=strsplit(check,'')[[1]]
        inputlist=strsplit(input,'')[[1]]
        matched="Yes"
        for(j in 2:length(checklist)) {
            pos=which(inputlist==checklist[j])[1]
            if(is.na(pos)) {
                matched="No"
                break()
            }
            inputlist=inputlist[pos:length(inputlist)]
        }
        if(matched=="Yes")
            output=append(output,as.character(pipeline$words[i]))
    }
    return(unlist(output))
}
