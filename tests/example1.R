# here you can change the dimensions of the PDF to be generated
pdf.width <- 7
pdf.height <- 7

# if you plot something within this function
# it will be rendered to the PDF
pdf.plot <- function() {
	plot(1:10)
}
