library(shiny)
library(shinyjs)
library(shinymanager)
library(httr)
library(ggplot2)
library(plotly)
library(caret)
library(dplyr)
library(plotrix)

# Configure Google OAuth credentials


# Define scopes
scopes <- c(
  "https://www.googleapis.com/auth/userinfo.profile",
  "https://www.googleapis.com/auth/userinfo.email"
)

# UI with Google login button
ui <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/chart.js"),
    tags$style(HTML("
    
     body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: linear-gradient(135deg, #a9c9ff, #ffbbec);
      animation: gradientAnimation 5s ease infinite;
      font-family: Arial, sans-serif;
      color: #333;
    }

    @keyframes gradientAnimation {
      0% {
        background: linear-gradient(135deg, #a9c9ff, #ffbbec);
      }
      50% {
        background: linear-gradient(135deg, #ffbbec, #a9c9ff);
      }
      100% {
        background: linear-gradient(135deg, #a9c9ff, #ffbbec);
      }
    }
      .nav-tabs {
      }
      .nav {
   padding-left: 0px;
   
    list-style: arabic-indic;
    display: flex;
    align-items: center;
    justify-content: right;
    margin: 20px;
    padding-right: 54px;
      }
     
}

  
  /* Custom chart wrapper styling */
  .chart-wrapper {
    margin-bottom: 20px;
    text-align: center;
  }

  .card__title {
    font-size: 18px;
    font-weight: bold;
    color: #2e3b4e;
  }

  /* Styling for page sections */
  .section {
    margin: 20px 0;
  }

  .divider {
    border-top: 2px solid #e0e0e0;
    margin: 20px 0;
  }

  /* Customize the welcome page text */
  #welcome-page h1 {
    font-size: 32px;
    font-weight: bold;
    color: #2e3b4e;
  }

  #welcome-page p {
    font-size: 18px;
    line-height: 1.5;
    color: #555;
  }
      }
      /* General Styles */
      body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #a9c9ff, #ffbbec);
        color: #333;
        margin: 0;
        padding: 0;
      }

      /* Login Panel Styling */
  #login-panel {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* Ensure the login panel takes up the full screen */
    animation: fadeIn 1s ease-out; /* Animation for fading in */
  }

  /* Login Card Styling */
  .login-card {
    background: linear-gradient(145deg, #6a9dff, #4facfe);
    padding: 40px;
    border-radius: 15px;
    width: 450px;
    box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
    text-align: center;
    box-sizing: border-box;
    transform: translateY(20px);
    animation: slideUp 0.6s ease-out; /* Animation for sliding up */
  }

  /* Animation for fading in the login panel */
  @keyframes fadeIn {
    0% {
      opacity: 0;
    }
    100% {
      opacity: 1;
    }
  }

  /* Animation for sliding up the card */
  @keyframes slideUp {
    0% {
      transform: translateY(20px);
      opacity: 0;
    }
    100% {
      transform: translateY(0);
      opacity: 1;
    }
  }

  /* Header Styles */
  .login-card h2 {
    color: #fff;
    font-size: 30px;
    font-weight: 700;
    margin-bottom: 25px;
  }

  /* Login Button Styling */
  .login-card .btn {
    background-color: #ff7c8e;
    color: white;
    padding: 15px 25px;
    border-radius: 50px;
    border: none;
    cursor: pointer;
    font-size: 18px;
    width: 100%;
    transition: background-color 0.3s ease, transform 0.2s ease-in-out;
  }

  .login-card .btn:hover {
    background-color: #ff4c5b;
    transform: translateY(-5px); /* Slight raise effect */
  }

  .login-card .btn:active {
    transform: translateY(0); /* Button returns to normal when clicked */
  }

  /* Message Styling Below the Button */
  .auth-message {
    margin-top: 20px;
    font-size: 16px;
    color: #f0f0f0;
  }

  /* Responsive Adjustments */
  @media (max-width: 768px) {
    .login-card {
      width: 80%;
    }
  }

      .sign-up {
        background: #e50914;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }

      /* Welcome Section */
      #welcome-page {
        padding: 0px 20px;
        text-align: center;
      }

      .section {
        padding: 20px 20px;
        margin-top: 1px;
      }

      .chart-section {
        display: grid;
        grid-template-columns: repeat(2, 1fr);  /* Creates a 2x2 grid */
        gap: 20px;
        margin-bottom: 50px;
        padding-left: 15px;
        padding-right: 15px;
      }

      .chart-wrapper {
        height: 329px;
        padding: 0 15px 15px 15px;
        border-radius: 10px;
        position: relative;
        background: #fff;
        border: 2px solid #eee;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
        cursor: pointer;
        box-sizing: border-box;
        transition: all 0.3s ease-in-out;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        overflow: hidden;
        aspect-ratio: unset;
      }

      /* Hover Effect */
      .chart-wrapper:hover {
        border: 2px solid #4facfe; /* Change border on hover */
        transform: scale(1.05); /* Slight zoom effect */
      }

      .info {
        flex: 1;
        padding: 15px;
      }

      .divider {
        height: 2px;
        background: #ddd;
        margin-top: 40px;
        margin-bottom: 40px;
      }

      .tooltip {
        display: none;
        position: absolute;
        bottom: 10%;
        left: 50%;
        transform: translateX(-50%);
        background-color: rgba(0, 0, 0, 0.8);
        color: var(--white);
        padding: 0.5rem 1rem;
        border-radius: 5px;
        font-size: 0.9rem;
        z-index: 10;
      }

      .card:hover .tooltip {
        display: block;
      }

      canvas {
        width: 100% !important; /* Make the canvas take full width */
        height: 100% !important; /* Make the canvas take full height */
      }
   
    "))
  ),
  tags$script(HTML("
    function createLineChart(canvasId) {
      const ctx = document.getElementById(canvasId).getContext('2d');
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['January', 'February', 'March', 'April', 'May', 'June'],
          datasets: [{
            label: 'EV Sales',
            data: [500, 600, 800, 700, 850, 900],
            borderColor: '#4facfe',
            fill: false
          },
          {
            label: 'Fuel Vehicle Sales',
            data: [700, 750, 650, 720, 710, 680],
            borderColor: '#e50914',
            fill: false
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });
    }

    function createBarChart(canvasId) {
      const ctx = document.getElementById(canvasId).getContext('2d');
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['Region A', 'Region B', 'Region C', 'Region D'],
          datasets: [{
            label: 'EV Sales',
            data: [1200, 900, 1500, 800],
            backgroundColor: '#4facfe'
          },
          {
            label: 'Fuel Vehicle Sales',
            data: [1000, 1100, 1400, 950],
            backgroundColor: '#e50914'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });
    }

    function createPieChart(canvasId) {
      const ctx = document.getElementById(canvasId).getContext('2d');
      new Chart(ctx, {
        type: 'pie',
        data: {
          labels: ['EV Sales', 'Fuel Sales'],
          datasets: [{
            data: [55, 45],
            backgroundColor: ['#4facfe', '#e50914'],
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });
    }

    function createDonutChart(canvasId) {
      const ctx = document.getElementById(canvasId).getContext('2d');
      new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: ['EV Sales', 'Fuel Sales'],
          datasets: [{
            data: [60, 40],
            backgroundColor: ['#4facfe', '#e50914'],
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });
    }

    function initCharts() {
      createLineChart('lineChart');
      createBarChart('barChart');
      createPieChart('pieChart');
      createDonutChart('donutChart');
    }
    document.addEventListener('DOMContentLoaded', initCharts);
")),
  
  
  # Tabset for Welcome, Login, and Dashboard
  tabsetPanel(id = "tabs",
              selected = "Welcome",
              # Welcome Tab
              tabPanel("Welcome", 
                       titlePanel("NEXTWHEEL"),
                       div(style = "position: absolute; top: 20px; right: 20px;",
                           actionButton("start_button", "Start", class = "btn btn-success")
                       ),
                       div(id = "welcome-page", class = "section",
                           h1("Welcome to EV and Fuel Sales Prediction"),
                           h3("This dashboard provides insights into the trends and predictions for Electric Vehicle (EV) and Fuel Vehicle sales."),
                           h3(" Explore data-driven visualizations that help in understanding how these markets are evolving over time."),
                           h3("From 2D charts to 3D charts, discover patterns and make informed decisions."),
                           div(class = "divider")
                       ),
                       
                       div(class = "chart-section",
                           div(class = "chart-wrapper",
                               tags$canvas(id = "lineChart"),
                               tags$h2(class = "card__title", "Line Chart")
                           ),
                           div(class = "chart-wrapper",
                               tags$canvas(id = "barChart"),
                               tags$h2(class = "card__title", "Bar Chart")
                           ),
                           div(class = "chart-wrapper",
                               tags$canvas(id = "pieChart"),
                               tags$h2(class = "card__title", "Pie Chart")
                           ),
                           div(class = "chart-wrapper",
                               tags$canvas(id = "donutChart"),
                               tags$h2(class = "card__title", "Donut Chart")
                           )
                       ),
                       div(class = "section",
                           h1("How to Use This Dashboard"),
                           h3("1. Explore the charts to gain insights into sales trends for EV and fuel vehicles."),
                           h3("2. Click on any chart to zoom in or view more details."),
                           h3("3. Upload your own dataset by clicking on the 'Upload Your File' button in the 'Dashboard' section."),
                           h3("4. Select the fields from your dataset you want to use for predictions (such as sales data and year)."),
                           h3("5. Click on the 'Predict Sales' button to see future sales predictions."),
                           div(class = "divider")
                       ),
                       # Contact Us Section
                       div(class = "section",
                           h2("Contact Us"),
                           p("For inquiries or feedback, feel free to reach out to us at:"),
                           p("Email: contact@nextwheel.com"),
                           p("Phone: +1 885226452"),
                           p("Address: SKIT JAIPUR"),
                           div(class = "divider")
                       )
              ),
              
              tabPanel("Login",
                       div(id = "login-panel", class = "section",
                           div(class = "login-card", 
                               h2("Login to Access the Dashboard"),
                               actionButton("google_login", "Login with Google", class = "btn btn-primary"),
                               br()
                           )
                       )
              ),
              # Dashboard Tab (content will be shown after successful login)
              tabPanel("Dashboard",
                       div(id = "dashboard-panel",
                           sidebarLayout(
                             sidebarPanel(
                               h4("Get Started with Your Data"),
                               p("Upload your dataset and customize your predictions below."),
                               
                               fileInput("userFile", "Upload Your File:",
                                         accept = c(".csv", ".xlsx"),
                                         buttonLabel = "Browse..."),
                               
                               checkboxGroupInput("fields", "Select Fields for Prediction:", choices = NULL),
                               numericInput("years", "Number of Future Years to Predict:", value = 5, min = 1),
                               actionButton("predictBtn", "Predict Sales", class = "btn")
                             ),
                             mainPanel(
                               h3("Sales Visualization", class = "plot-title"),
                               tabsetPanel(
                                 tabPanel("Line Plot", plotlyOutput("linePlot")),
                                 tabPanel("Bar Plot", plotlyOutput("barPlot")),
                                 tabPanel("Scatter Plot", plotlyOutput("scatterPlot"))
                               )
                             )
                           )
                       )),
              tabPanel("3D Visualization",
                       div(id = "3d-panel", class = "section",
                           h2("3D Pie Chart Visualization"),
                           p("Explore a 3D representation of sales predictions as a pie chart."),
                           plotOutput("threeDPieChart", height = "600px") # Use plotOutput for base R plotting
                       )),
              # Logout Tab
              tabPanel("Logout",
                       div(id = "logout-panel", class = "section",
                           h2("Logout"),
                           p("Click the button below to log out and end your session."),
                           actionButton("logout_button", "Logout", class = "btn btn-danger"),
                           uiOutput("logout_message")
                       ))
  )
)

# Server logic for Google Authentication
server <- function(input, output, session){
  
  observeEvent(input$start_button, {
    updateTabsetPanel(session, "tabs", selected = "Login")
  })
  logged_in <- reactiveVal(FALSE)  # Track login status
  
  observeEvent(input$tabs, {
    selected_tab <- input$tabs
    
    # Check if the user is not logged in and trying to access restricted tabs
    if (!logged_in() && selected_tab %in% c("Dashboard", "3D Visualization")) {
      showNotification("Please log in to access this section.", type = "warning")
      updateTabsetPanel(session, "tabs", selected = "Login")
    }
  })
  
  # Reactive value to store user info
  user_info <- reactiveVal(NULL)
  
  # Handle Google Login
  observeEvent(input$google_login, {
    tryCatch({
      # Google OAuth token and user info retrieval (same as original)
      google_app <- oauth_app(
        appname = "google",
        key = google_client_id,
        secret = google_client_secret
      )
      google_token <- oauth2.0_token(
        endpoint = oauth_endpoints("google"),
        app = google_app,
        scope = scopes,
        cache = FALSE,
      )
      user_request <- GET(
        "https://www.googleapis.com/oauth2/v2/userinfo",
        config(token = google_token)
      )
      user_data <- content(user_request)
      user_info(user_data)
      auth_status(TRUE)
      
    }, error = function(e) {
      showNotification(paste("Login failed:", conditionMessage(e)), type = "error")
    })
    logged_in(TRUE)
  })
  
  # Handle logout
  observeEvent(input$logout_button, {
    showModal(
      modalDialog(
        title = "Confirm Logout",
        "Are you sure you want to log out?",
        easyClose = FALSE,
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirm_logout", "Logout", class = "btn-danger")
        )
      )
    )
  })
  
  observeEvent(input$confirm_logout, {
    removeModal() # Close the confirmation modal
    # Invalidate the token and clear session variables
    session$reload()
  })
  
  # Placeholder for data processing and prediction logic
  selected_data <- reactive({
    req(input$userFile)
    file <- input$userFile
    ext <- tools::file_ext(file$name)
    if (ext == "csv") {
      read.csv(file$datapath)
    } else if (ext %in% c("xls", "xlsx")) {
      readxl::read_excel(file$datapath)
    } else {
      showNotification("Unsupported file type. Please upload a CSV or Excel file.", type = "error")
      return(NULL)
    }
  })
  
  observeEvent(selected_data(), {
    data <- selected_data()
    req(data)
    updateCheckboxGroupInput(session, "fields",
                             choices = setdiff(colnames(data), "YEAR"))
  })
  
  prediction_data <- eventReactive(input$predictBtn, {
    data <- selected_data()
    req(data)
    req(input$fields)
    data <- data %>% mutate(year_num = as.numeric(format(as.Date(data$YEAR, "%Y-%m-%d"), "%Y")))
    training_data <- data %>% select(year_num, all_of(input$fields))
    model <- train(as.formula(paste(input$fields[1], "~ year_num")), data = training_data, method = "lm")
    future_years <- max(training_data$year_num) + (1:input$years)
    predictions <- predict(model, newdata = data.frame(year_num = future_years))
    data.frame(Year = future_years, Prediction = predictions)
  })
  
  # Render Line Plot for Sales Prediction
  output$linePlot <- renderPlotly({
    pred_data <- prediction_data()
    req(pred_data)
    p <- ggplot(pred_data, aes(x = Year, y = Prediction)) +
      geom_line(color = "blue") + geom_point(color = "blue") +
      labs(title = "Sales Prediction - Line Chart", x = "Year", y = "Sales") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Render Bar Plot for Sales Prediction
  output$barPlot <- renderPlotly({
    pred_data <- prediction_data()
    req(pred_data)
    p <- ggplot(pred_data, aes(x = factor(Year), y = Prediction)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "Sales Prediction - Bar Chart", x = "Year", y = "Sales") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Render Scatter Plot for Sales Prediction
  output$scatterPlot <- renderPlotly({
    pred_data <- prediction_data()
    req(pred_data)
    p <- ggplot(pred_data, aes(x = Year, y = Prediction)) +
      geom_point(color = "darkorange") +
      labs(title = "Sales Prediction - Scatter Plot", x = "Year", y = "Sales") +
      theme_minimal()
    ggplotly(p)
  })
  
  #3d
  output$threeDPieChart <- renderPlot({
    pred_data <- prediction_data()
    req(pred_data)
    
    # Ensure data is numeric and labels are character
    values <- as.numeric(pred_data$Prediction)
    labels <- as.character(pred_data$Year)
    
    # Check if the data is valid for plotting
    if (length(values) > 0 && length(labels) > 0 && sum(values) > 0) {
      pie3D(
        values,
        labels = paste(labels, sprintf("%.1f%%", 100 * values / sum(values))), # Add labels with percentages
        main = "3D Sales Prediction Pie Chart",  # Title for the chart
        col = rainbow(length(values)),           # Generate colors dynamically
        explode = 0.1,                           # Add spacing between slices
        labelcex = 0.8,                          # Adjust label text size
        start = pi/2                             # Rotate starting point for better alignment
      )
    } else {
      plot.new()
      title("No valid data available for 3D Pie Chart")
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server, options = list(port=1420))