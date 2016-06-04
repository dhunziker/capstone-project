#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
shinyUI(navbarPage("Capstone Project", theme = "bootstrap.min.css",
    tabPanel("Next Word Prediction",
        tags$head(tags$style(HTML('.container {margin-left: 0px;}'))),
        mainPanel(
            h2("Next Word Prediction"),
            uiOutput("predictions"),
            tags$textarea(id="userInput", rows = 3, cols = 40, class="form-control shiny-bound-input", style = " margin-top: 5px; margin-bottom: 5px", ""),
            p("Start typing your text in the text area above. Use the buttons to apply predicted words. For more details, see the Documentation tab."),
            p("NOTE: Please be patient for the buttons to appear first, it might take a short period of time while the app is waking up.")
      )
    ),
    tabPanel("Documentation",
        h2("Documentation"),
        p("This documentation is meant to help you understand how the application works, how it can be used and what its limitations are."),
        h3("How it works"),
        p("English twitter, blog and news data is read and transformed into document frequency matrices (from unigrams up to fivegrams) using the quanteda package. Count and pattern based filters are applied in order to keep the amount of data manageable."),
        p("The resulting n-gram models are reshaped to simplify lookups on a single column using just a prefix. An algorithm called \"stupid backoff\" is then used to calculate scores for each of the available n-grams which are used as a pseudo probability for prediction."),
        h3("How to use it"),
        p("The aim was to keep the functionality similar to the word prediction available on iPhone's messaging application (or similar brand of phone). This should speed up the learning process for new users significantly."),
        p("When presented the empty text area, just start typing and the application will suggest upcoming words based on your input. This is done based on 2 scenarios:"),
        tags$ol(
            tags$li("The current input ends with a space: the next word is suggested"),
            tags$li("The current input doesn't end with a space: the algorithm will try and suggest/complete your current word")
        ),
        p("However, for some words that are not recognized at all (like names or anything gibberish), the auto completion will not be able to make any suggestions and instead display the current word surrounded by double quotes (\")."),
        p("Also, please be aware that the application currently won't recognize apostrophes ('). It will just leave them out when suggesting new words, so just do the same when writing (I'm becomes Im)"),
        h3("Limitations"),
        p("Here's a list of things that need improvement (just so you know ;-):"),
        tags$ol(
            tags$li("Start/end of sentence are not recognized as such"),
            tags$li("Punctuation has been removed during the model generation (i.e. no apostrophes)"),
            tags$li("Profanities haven't been removed (just for the fun of it)"),
            tags$li("Supports ASCII character set only and therefore will not recognize most foreign words"),
            tags$li("No dictionary has been applied, random twitter language (like rt, lol) will show up too frequently"),
            tags$li("All predictions will be lower case, although upper case input is recognized")
        )),
    tabPanel("About",
        h2("About"),
        p("This project is the last in a series of 10 courses that are all part of the Data Science Specialization taught by the Johns Hopkins University. The following links provide more details about this project as well as some very helpful resources used during the project."),
        tags$ol(
            tags$li(tags$a(href = "https://github.com/dhunziker/capstone-project", "GitHub repository")),
            tags$li(tags$a(href = "https://www.coursera.org/learn/data-science-project", "Project page on Coursera")),
            tags$li(tags$a(href = "http://www.aclweb.org/anthology/D07-1090.pdf", "Stupid Backoff (Brants et al., 2007)")),
            tags$li(tags$a(href = "https://www.youtube.com/watch?v=s3kKlUBa3b0", "Stanford NLP videos")),
            tags$li(tags$a(href = "https://cran.r-project.org/web/packages/quanteda/quanteda.pdf", "Quanteda R package"))
        ),
        br(),
        p(tags$a(href = "https://uk.linkedin.com/in/dennis-hunziker-b3251282", "Dennis Hunziker")))
))
