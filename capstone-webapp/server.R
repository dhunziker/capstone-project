#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(stringr)

finalModel <- readRDS("finalNgramModel.rds")
finalUnigramModel <- readRDS("finalUnigramModel.rds")

ngramFind <- function(sentence, input = "") {
    sentence <- c(word(sentence, -1, -1),
                  word(sentence, -2, -1),
                  word(sentence, -3, -1),
                  word(sentence, -4, -1))

    model <- finalModel %>% filter(prefix %in% sentence)
    if(str_length(input) > 0) {
        model <- model %>% filter(grepl(paste0("^", input), next_word))
    }

    if(nrow(model) == 0 && input != "") {
        as.data.table(c(paste0("\"", input, "\"")))
    } else {
        suppressWarnings(model[, s := max(s), by = next_word])
        model %>% distinct(next_word) %>% select(next_word) %>% head(3)
    }
}

refreshInput <- function(session, x, inputFilter, selectedValue) {
    x <- tolower(x)
    print(paste0("Selected value: ", as.character(selectedValue)))
    newUserInput <- if(is.na(x)) {
        as.character(selectedValue)
    } else if(inputFilter == "") {
        paste0(x, as.character(selectedValue))
    } else {
        input <- word(x, 1, -2)
        if(is.na(input)) {
            as.character(selectedValue)
        } else {
            paste0(input, " ", as.character(selectedValue))
        }
    }
    updateTextInput(session, "userInput", value = paste0(newUserInput, " "))
}

shinyServer(function(input, output, session) {

    values <- reactiveValues()

    observe({
        x <- tolower(input$userInput)
        inputFilter <- ""

        predictions <- if(str_sub(x, -1) == " ") {
            ngramFind(str_trim(x))
        } else {
            inputFilter <- word(x, -1)
            ngramFind(str_trim(word(x, 1, -2)), inputFilter)
        }

        # Case where we don't recognize the previous word at all
        if(nrow(predictions) == 0) {
            predictions <- finalUnigramModel %>% select(next_word) %>% head(3)
        }

        # Store the values for later use
        values$inputFilter <- inputFilter
        values$data <- predictions

        output$predictions <- renderUI({
            lapply(1:nrow(predictions), function(i) {
                actionButton(paste0("button", i), predictions[i,])
            })
        })
    })

    # This feels hacky, but couldn't find an easy way to make it dynamic
    observeEvent(input$button1, {
        refreshInput(session, input$userInput, values$inputFilter, values$data[1,])
    })
    observeEvent(input$button2, {
        refreshInput(session, input$userInput, values$inputFilter, values$data[2,])
    })
    observeEvent(input$button3, {
        refreshInput(session, input$userInput, values$inputFilter, values$data[3,])
    })

})
