source("server.d/sidebar.dataset.r")
source("server.d/sidebar.working.r")

server = function(input, output, session) {
    observe({
        updateSelectInput(session,
            "dataset",
            choices = datasets,
            selected = datasets[1]
        )
    })
}