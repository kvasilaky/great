#------------------------------------------------------------------------------#
'''
Basics Code for learning R

You should execute every R code command in this file to see how it works. You
can simply highlight an indented line and press CTRL+R to move it to the R 
Console and execute it. Understanding the R code explained in this file requires 
reading the help files that can be found with R code as explained below.

Make sure your working directory is set as you want it, e.g., check the working 
directory and set it as follows:
'''

	getwd()


	setwd(file.path("C:","R"))

#------------------------------------------------------------------------------#
'''
Basics: Vectors and Object Creation

The basic building blocks in R are typically defined as simple lists or vectors.
Alternative ways can be used to create the same thing in R. For example, the 
following three lines of code define the same 'x'.
'''
	x <- c(1, 2, 3, 4, 5)

	assign("x",c(1, 2, 3, 4, 5))

	c(1, 2, 3, 4, 5) -> x

'''
The symbol '<-' is used to define an equality. In many cases, you can use '='
instead of '<-', but this is not always acceptable. In R everything is an 
object, so you will refer to 'x' as an object. Further information is given 
later about how to classify objects according to what kind of information they 
contain.

You can open the help guides to understand more about the 'c()' and 'assign()' 
functions. This is key to adding new functions to your toolkit. 
'''

	help(c)
		
	help(assign)

'''
For any function used in these notes, the help documentation provides a 
description, the usage, a review of arguments, and details, along with an 
example. You should refer to these help guides often, especially when you come 
across a new function. 

To view the object in the R Console, simply reference the object name.
'''

	x

#To view the object in the R Editor, use the 'edit()' function.  
  view(x)
	edit(x)
  x[3]<-22

'''
Note: Be careful when you use the 'edit()' function. As its name suggests, this
statement allows you to change numbers, which will be saved over the original 
data. Also, you must close the 'x - R Editor' window before you are allowed to 
run other commands because R will expect the data object to be adjusted while 
the editor window is open.

To check what class the object belongs to use the 'class()' function.
'''
  x<-1 or x<-"k"
	class(x)
  typeof(x)
  dim(x)

'''
You can apply an expression to a vector of numbers as if they were a single 
number. This is a very useful way to write clean and efficient code.
'''

	1/x
  x^2
  sqrt(x)

'''
The object 'x' is a collection of five numbers. This expression creates a
collection of five numbers where each element is the reciprocal of the element 
in the original 'x' object. 

You can define collections of numbers with objects.
'''

	y <- c(x, 0, 1/x)
  y <- c(x, 0, 1/x, "katya")

'''
An important point to remember is that R works with vectors or lists of 
different sizes. Consider, for example:
'''
  y <- c(x, 0, 1/x)
	v <- 2*x + y + 1		
	v

'''
In this example, x has fewer elements than y, but R will still allow the object
'v' to be created. In many other programs like MATLAB an error would be issued 
and 'v' would not be created. In R, the information in 'x' is recycled to 
create a vector that is the same length as 'y'. This can be helpful at times,
but problematic if you are careless. 

Many functions in R accept an object as an argument. For example, the first 
statement uses the 'min()' and 'max()' functions to return an object containing 
the minimum and maximum elements of the 'x' vector.
'''

	c(min(x), max(x))

	mean(x)

	sum(x)/length(x)

	var(x)

	sum((x-mean(x))^2)/(length(x)-1)   # Verify the denominator used by var()

'''
Often, you will need to sort data. The following R code calls up the help guide 
to learn how to use the 'sort()' function. For any function, you can call up 
the help guide in this way. You will find that R has very intuitive function 
names. If you do not remember a particular name, but have an idea what you want 
to do, try calling the 'help()' function with your best guess. Often this will 
find the information you need.
'''

	help(sort)

	sort(x)

	order(x)
  o <- order(x, decreasing=TRUE)
  #Name arguments makes your code easier to read
  o <- order(x, decreasing=TRUE,na.last=TRUE)
  o <- order(x, na.last=TRUE,decreasing=TRUE)

	sort.list(x)


#You can us the same function to sort text as well as numbers,


	s <- c('a','b','z','c')

	sort(s)
  
  s <- c('a','b','z','c',1,2,0)
  
  sort(s)


#You can define a collection of numbers in a variety of ways in R.

	1:30

	30:1

'''
Note how the two vectors of information below are different after setting n 
equal to 10. In the first case, a list is defined and then 1 is subtracted from 
each element. The next case subtracts 1 from n and then builds the list from 1 
to n-1. This is a subtle but important point, especially because it differs 
from other programs like MATLAB.  
'''

	n <- 10

	1:n-1

	1:(n-1)
  
  z<-1:30
  z<-seq(1,30)
  z<-c(1:30)


#The 'seq()' function defines a sequence of numbers. Try the following to see how they work.

	seq(-5, 5, by=.2) 

	seq(length=51, from=-5, by=.2)


#The 'rep()' function repeats an object a specified number of times.


	rep(x,times=5)

	rep(x,each=5)

'''
Note the difference in outcomes of these two operations.

Logicals (<, <=, >, >=, ==, !=) are necessary to understand for a number of 
reasons. First, lists or vectors of 'TRUE' and 'FALSE' have special properties 
and uses in R. Second, many functions return results in terms of a logical 
vector. Third, using logical statements are necessary when you are searching 
for information. Observe results of the following:
'''

	x <- c(1, 2, 3, 4, 5)

	d <- x>3

	d

	!d

	d <- x>3 & x<1

	d

	d <- x>3 | x<2

	d
  
  d

'''
You must be aware of how R treats missing data. In R, a missing value is 
different from a number that does not exist. That means you need to be careful 
how you use NA and NAN, especially in statistical analysis. Try the following: 
'''

	x <- c(1:5, NA, 4, NA, 9:6)

	x

  #Tells you which values are NA
	ind <- is.na(x)
  #Boolean masking/indexing
  x[is.na(x)] <-100
  x[x==100]<-99
  
  #Subsetting
  x <- c(1:5, NA, 4, NA, 9:6)
  x<-subset(x, !is.na(x))


'''
Next, consider the use of strings that include a number. The key to any good 
code is flexibility. You never want to specify a list of, say, 10 elements, 
when the number 10 may change. Instead, think about how you can define a list 
with n elements. For example, instead of the first statement below, use the 
next two statements.
'''

	paste(c("X","Y"), 1:10, sep="")

  #More flexible, less explicit to one task
	i<-10

	paste(c("X"),1:i,sep="")


#You can use the 'paste()' function to create strings with embedded calculations.


	help(paste)


#For example:

	paste("There are",choose(50,3),"ways to select 3 elements from 50")

'''
You do not have to convert numbers to a strings, and can thus include 
mathematical calculations like choose(50,3), because this is input to a 
function.

EXERCISES:

	- Modify the last line of code above by defining parameters equal to 3 and 
	  50 above the paste function and substitute the parameter names in the 
	  paste statement, which allows the pasted expression to vary.

	- Logical tests are useful for accessing elements from a larger set of 
	  information. The TRUE values can be identified. For example, after you 
	  run all of the code above, run 'x[d]'. Explain what this does. 

	- Find out what happens when using the 'sum()' function if the list of 
	  numbers includes NA. Does this change if you replace an NA value 
        with NA? In MATLAB this is an issue, so you should be sure how it is
        handled in R. 
'''

#------------------------------------------------------------------------------#
'''
Basics: Arrays and Matrices

An array is an ordered arrangement of things. An array is commonly arranged into
columns and rows. Since they have order, you should be careful about how to 
build arrays and access information in them. Compare the following:
'''

	y <- c(1,2,3,4)

	y

	class(y)

	View(y)
  
  #Z has a dim, whearas a vector or list
	z <- array(c(1,2,3,4))

	z

	class(z)

	View(z)

	q <- array(1:100)

	q

	class(q)

	View(q)

'''
The array() function allows you to specify the dimensions. For example, the
following code produces a list of 100 numbers and places them into an array 
with 10 rows and 10 columns. Note how R fills in this array with the series of 
numbers. The reason for this is discussed further below.
'''

	x <- array(1:100, dim=c(10,10))
  x <- array(1:100, dim=c(10,10,10))

	x

	class(x)

	total_sum = sum(x)

	total_sum

	help(sum)		


#You can sum across the rows or columns of an object with these functions: 

	colSums(x)

	rowSums(x)

#In the following, the object 'i' is an array with 10 rows and 2 columns.

	i <- array(c(1:10,10:1), dim=c(10,2))
  i <- array(c(1:10), dim=c(10,2))

	i

#The following give several alternative ways to define a matrix.

	B <- diag(1,10)

	C <- array(rnorm(100), dim=c(10,10)) 

	class(C)

	D <- diag(c(10,5,9,3,8))

#Each element in an array has a location. You can specify this location with 
#two numbers if the array has 2 dimensions. 

	x[1,10]
  x[1]

	x[2,9]

	x[10,1]

#Since 'i' is a list of 10 pairs, you can also reference numbers according to 
#the information in each row of 'i'. 
  
  #Clever!
	x[i]

#You can use the information contained in i to redefine elements of the array 
#'x'.

	x[i] <- 0

	x

#The following demonstrates how to use the 'matrix()' function. 
#Note: matrices are arrays with only 2 dimensions.
#Arrays can have any number of dimensions including 1, 2, 3, etc.

	m <- matrix(data=1:12,
			nrow=4,
			ncol=3,
			dimnames=list(c("r1","r2","r3","r4"),c("c1","c2","c3")))	

	edit(m)

	

	class(m)

#Note how data in the matrix is defined by 'data=1:12'. You can access 
#information in the first row and first column as follows.

	m[1,1]
	
#Or you can access all information located in the first column.

	m[,1]

#Or you can access all information located in the first row.

	m[1,]

#To build an nxn matrix:

	n <- 10

	M <- matrix(data=1:n^2,
			nrow=n,
			ncol=n,
			dimnames=list(paste("r", 1:n, sep=""),paste("c", 1:n, sep=""))
			)	

	edit(M)

'''
Note how data in the matrix is defined by 'data=1:n^2'. The expression defining 
the dimension names might look complicated. But it is simply a series of nested 
expressions like those used above. The paste() function creates a sequence of 
strings based on what is designated to be pasted together. The list() function 
is used because two vectors are used to convey the row and column information. 
This expression does not use the c() functions that are used to collect 
information in the previous matrix example. This example uses only one string 
in the paste() function, making c() unnecessary. You can test this below by 
showing that the c() functions are not required.  
'''
	c(paste(c("r"), 1:n, sep=""))

	paste("r", 1:n, sep="")

'''
You should be careful to note how R has constructed this matrix. Like MATLAB, R
works down columns. The reason for this has to do with vectorizing a matrix by 
stacking the columns to produce one long vector, which is a linear 
transformation. In R, a matrix is regarded as a long vector. So when you want to
point to a specific element of a matrix, you can either use the [row,column] 
notation or you can simply use a single number referencing an array element. For 
example, the 11th element of the matrix M is located in the first row, second 
column. 
'''

	M[11]

	M[1,2]

'''
EXERCISES: 

	- Find out how to draw 100 numbers from a uniform distribution on [0,1].

	- Place 100 numbers drawn between 1 and 5 in a matrix and change all 
        numbers between 2 and 3 to 0.

'''
#------------------------------------------------------------------------------#
'''
Example: Matrix Operations

Remember that matrix multiplication is denoted by %*% rather than *. An 
operation denoted by A*B produces a matrix in which each element is the product
of the corresponding elements of A and B.

A very useful function when working with matrices is the cbind() function, 
which combines objects listed as arguments by columns. R will always scan the 
arguments and find the longest vector and then will recycle all other vectors
to ensure they all have the same number of rows. A similar function called
rbind() works along rows. 
'''

	help(cbind)

	X <- cbind(1, runif(100), runif(100))
	B <- c(1,2,3)


#To see the difference between '%*%' and '*', run the line of code below and 
#look at the output in the R Console window. 

	X*B vs X%*%B

  C <- array(rnorm(10), dim=c(2,2)) 
  B<-diag(1,2)
  #Element wise
  B*C
  #Matrix multiplication
  B%*%C

'''
You should note that the first column of X was a full column of 1s, but the 
first column of X*B is [1, 2, 3, 1, 2, ...]. Given how R stacks columns, the 
second element in X is multiplied by the second element in B, then the third 
element in X (third row, first column) is multiplied by the third element in B.
At this point, the information in B is exhausted, so R will then recycle this 
information because X has more elements. The fourth element in X (fourth row,
first column) is then multiplied by the first element in B. 

Recall that everything in R is an object and every object is associated with a 
class. Determine the class of objects X and B. 
'''

	class(X)
	class(B)

'''
Based on how X and B are defined, they have been associated with different 
classes. R views X as a 'matrix' and B as a 'numeric' object. You can check
to see if this difference is due to the use of the 'cbind()' function.
'''

	B <- cbind(1,2,3)

	class(B)


#Indeed, the use of this function changes the object's class. These points are 
#necessary to keep in mind. Consider an alternative way to change the class of B.

	B <- as.matrix(c(1,2,3))

#Given that B is now an object of a different class, the way R uses information 
#in B will change. Consider exactly the same operation above: 

	X*B

'''
An error message is issued stating "Error in X * B : non-conformable arrays".
This short example shows that class matters. Some functions that are only 
applicable when an object is a "matrix". For example, the 'dim()' function 
returns the dimensions of a matrix. The order is always along rows, columns, 
and so on. 
'''

	dim(X)
	dim(B)
	dim(c(1,2,3))

'''
If you want to break out the information, then specify the location in the 
vector.
'''

	number.row.X <- dim(X)[1]
	number.col.X <- dim(X)[2]

#------------------------------------------------------------------------------#
'''
Basics: Lists and Data Frames

LISTS: A list in R is simply an ordered group of objects. Consider the example: 
'''
                               
	ltest = list(name="Fred",wife="Mary",no.children=3,child.ages=c(4,7,9))

'''
The first component of the list is 'name'. Some components of the list are text
and some are vectors of numeric data. The concept of a list is important because
R does not allow defining a matrix that has both numeric and string data.

Information in a list can be accessed in several ways. Try the following:
'''
                               
	ltest[2]

	ltest[[2]]

'''
Note that [2] selects the second component whereas [[2]] selects the information 
inside the second component.					

You can also access elements of a list without having to remember where in the 
order certain information is located with the following:
'''
                               
	ltest$wife							 

	ltest[["wife"]]

	ltest$child.ages

	ltest$child.ages[2]

	ltest[4][2]							

'''
Note this latter statement produces an error because [4] accesses the component
of the list rather than the elements inside the component. The one of the 
following to access the desired information:
'''
                               
	ltest[[4]][2]						

	ltest[["child.ages"]][2]						

#To determine how many components are in the list:

	length(ltest)		

#You need not supply names for each component of a list.

	ltest = list("Fred", "Mary", 3, c(4,7,9))

	ltest[[3]]							

#But, without names, you must rely on the location in the list.

	ltest[[4]]
  ltest[[4]][2]

	X = 1:100
	Y = c("A","B","C","D")
	Z = list("AA","BB","CC")

	XYZ = list(X,Y,Z)

	XYZ[[1]][99]

	XYZ[[2]][2]

	combine = c(ltest, XYZ)

	mode(combine)

	combine[[6]][1]

'''
DATA FRAMES: A data frame in R is simply a collection of lists. You need to know
what kind of lists can be included in a data frame. You can think of a data 
frame just like a matrix except that you can have columns of strings along with 
columns of numbers. Or if you are coming from a datbase background,it is similar to a table in a
ER Schema. Restrictions on the lists included in a particular data 
frame are reasonable once you view the data frame as a matrix. Try the 
following: 
'''
	str <- c("A","B","C","D")
	num <- c(1,2,3,4)
	loc <- c(TRUE,FALSE,TRUE,TRUE)

	class(str)
	class(num)
	class(loc)

	dataf <- data.frame(d1=str,d2=num,d3=loc)
  head(dataf)
  names(dataf)
  dataf[1,]
  dataf[,1]

	dataf

	View(dataf)

'''
The data frame is composed of different variables, e.g., 'd1', 'd2' and 'd3'. 
The ability to make reference to these variable names is not automatic. For 
example, try the following line of code. 
'''
                               
	d2*2

'''
You will see that R cannot find this variable or object 'd2'. To move the list
of names into the R workspace, you need to use the 'attach()' function. This
attaches the list of names from the data frame into the main list of objects R 
recognizes. You may not want to do this if you are working with multiple dataframes at once.
'''
                               
	attach(dataf)

	d2*2

'''
Once you attach the data frame, you can use the name in your programming 
statements. Use the 'detach()' function if you want to remove variable names
from the workspace.
'''
                               
	detach(dataf)

	d2*2

'''
Executing these statements reveals that you no longer have access to the names 
Once you detach the data frame, however, the information in the data frame can 
always be referenced by using the data frame name along with the variable of
interest.  
'''
	dataf$d1 

	dataf$d2

'''
Once you have a data frame created, we can always add information to it as long 
as the new information has dimensions similar to the original data. For example, 
the first line below will produce an error since you are trying to combine a 
variable with only three elements into the data frame that has four elements.
'''
	dataf2.error <- data.frame(dataf,d4=str[1:3])
  dataf$dataf2.error <- data.frame(dataf,d4=str[1:4])

	dataf2 <- data.frame(dataf,d4=str)

  #Or create the var outside of the df
  d4<-c(1:4)
  dataf2$d4<-d4

	dataf2
  View(dataf2)



'''
LOOPS: The example below shows how you can draw many sets of random numbers and save 
the information in a data frame that you can then use as an input into other 
functions. 

The following code is the first example of a for loop in R. Each for loop 
defines a variable, for example i, which changes value with each loop. The 
statement (i in 1:100) tells R to start with i=1 and repeat the loop with 
i=2, i=3, and so on, ending with i=100. The code will loop over everything in 
{}. Each loop begins with a conditional expression. The code checks to see if 
i==1. If this is TRUE, then a data frame is created with one set of random 
numbers. If this is FALSE, then another set of random numbers is attached to 
the data frame already created. 
'''

q <- array(1:100)

for (i in 1:100) {
  print(q[i])
}

  
}
#Basic syntax
  for (i in 1:nrow(q)) {
    print(q[i])
  }
                               
	for (i in 1:101) 
		{
		if (i==1) 
			X <- data.frame(i=rnorm(100, mean=3, sd=2))
		else 
			X <- data.frame(X, i=rnorm(100, mean=3, sd=2))
		}

	edit(X)

#Plot the first and second 'columns' of the dataframe 'X'. 

	plot(X[[1]],type="l",col='blue')
	lines(X[[2]],type="l",col='red')

'''
The dataframe object 'X' can be used as an input into various functions. For 
example, the code below finds 'var(X)'. Since 'X' is a dataframe with many 
columns, the 'var()' function will compute the variance-covariance matrix 
between the columns of 'X'. 
'''
                               
	help(var)

'''
To study the variances by columns, the 'diag()' function can be applied to the 
variance-covariance matrix 'var(X)'. A histogram based on these values along 
the diagonal can be plotted as follows:
'''
	hist(diag(var(X)))

	class(X)

'''
If you have information stored in a data frame, you can convert it into a matrix 
using the 'as.matrix()' function. To do this, all the information must be of the
same type.
'''
                               
	X_m = as.matrix(X)

	X_m

	class(X_m)

'''
The following example shows that if you try to convert a data frame including 
both numbers and strings, R will convert any numbers to strings. Thus, 9 will 
show up as the string "9". If you want to use this information as numbers, you 
will have to convert the strings to a numbers.
'''
	dataf <- data.frame(d1=c("A","B","C","D"),d2=c(1,2,3,4),
		d3=c(TRUE,FALSE,TRUE,TRUE))

	dataf_m = as.matrix(dataf)

	dataf_m

'''
As you can see, R issues no error and provides no warning that an important 
change has been made. The change is not to the actual information but in how R 
understands the information.
'''
	dataf_m[1,2]

	dataf_m[1,2]+dataf_m[2,2]

#This generates an error because you must use the 'as.numeric()' function to 
#convert strings of numbers to actual numbers. 

	as.numeric(dataf_m[1,2])

	as.numeric(dataf_m[1,2])+as.numeric(dataf_m[2,2])

                               '''
EXERCISES:

	- Using 'var(X)', the variance-covariance matrix, find a method or 
        function to extract information from above or below the diagonal. 

	- Confirm that you should expect zero correlation between the columns of 
	  'X' as generated above.

#------------------------------------------------------------------------------#
Example: Data Frames, Data Management, and Data Export

Next, consider an example based on a premade dataset that is available in R. The
object is named 'state'. It includes information related to the 50 states of the
United States of America. This is a good example of how you can manage data in 
R. Typically, data can be organized and packed into objects such as this. 

R has a number of datasets. You can see the full list by running the 'data()' 
command after including the package 'datasets' in your R program. With any of 
these datasets, you can use the 'help()' function to learn more about what is 
included. To learn what is included in the 'state' dataset: 
'''
	help(state)

'''
As you can see from the R documentation, this dataset has a number of different 
objects associated with it, including a 'state.abb' object, a 'state.area' 
object, and an object called 'state.x77'. These are examples of different types 
of data that can be included in a dataset (character vector, numeric vector, 
and matrix). From the details, you see that "all data are arranged according to 
alphabetical order of the state names". This provides the key to how data are 
organized in all the different objects.  
'''

	class(state.x77)

	edit(state.name)

#You can convert this data into a matrix, which will cause the edit() function 
#to return something that is easier to process. 

	SNm <- as.matrix(state.name)

	edit(SNm)

'''
Use the information on the order of state names to access information from the 
other objects that are related to a specific state. For example, California is 
the 5th state in the order, so you can access California data as follows:
'''
	state.abb[5] 

	state.area[5]

	state.x77[5,]       # This accesses the 5th row because this is a matrix.

'''
You can take all of these different objects and pack them into a single 
data frame. This is not necessary, but is sometimes useful. Certain parts of 
this data frame have multiple columns with names. For example, the 
'state.center' has columns related to 'x' and 'y'. When you build a data frame,
R will append these names to the name 'center' as below. So the final data 
frame will have columns 'center.x' and 'center.y'.  
'''
	alld = data.frame(name=state.name, abb=state.abb, area=state.area, 
		            center=state.center, division=state.division,
		            region=state.region, stats=state.x77)

	edit(alld)

'''
This will present all data as you would expect if you were working in a program 
like SAS or STATA. You should be aware that R uses information from the first 
input into the data frame as the row.names. You can change this by using the 
'row.names()' function to change these, for example, to a number list.
'''
	row.names(alld) <- 1:50

	edit(alld)

#This removes the 'row.names' column. Close the edit window. You can use notation
#as when working with a matrix to access all information in any given column or row. 

	alld[,1]

	alld[1,]

#Now you can do many operations with the data frame. For example, you can access 
#the top 5 state abbreviations with the largest life expectancy. 

	alld[order(-alld$stats.Life.Exp),][1:5,2]

	help(order)

'''
This tells R to first order all rows of 'alld' according to the order of the 
single column named 'Life.Exp'. The 'order()' function ordinarily orders from 
smallest to largest, but if you place a negative symbol ('-') in front of the 
variable then it will order from largest to smallest. You should try to run 
the 'order()' function alone to see what it produces:
'''
	order(-alld$stats.Life.Exp)

'''
As you can see, what is retuned is not the actual sorted data, but a list of 
numbers. These numbers are the locations of the original data. The first number 
is 11, indicating that the 11th element is the largest. You can check this.
'''
	max(alld$stats.Life.Exp)==alld$stats.Life.Exp[11]

'''
R takes this list of locations and applies it to the rows and mixes the rows 
accordingly. Because no information is given in the column location, R will 
sort all columns.
                               
The 'summary()' function will break down the data frame and provide summary 
information for each component. If the data is factors or strings, then the 
summary will count specific occurrences. If the data are numeric then the 
summary will provide min/max and quantile information. 
'''
                               
	summary(alld)

	sumKeep <- summary(alld)

'''
The latter statement assigns the output from the 'summary()' function to an 
object named 'sumKeep'. If you check the class of this object, you will see that
it belongs to the "table" class. What are the advantages of having an object 
belong to this class?
'''
                               
	class(sumKeep)

	str(alld)           # A different way to view info related to data frames.

#Now load the 'lattice' package. 

	install.packages("lattice")

	library("lattice")

'''
The lattice package offers a number of ways to produce graphics in R. The 
options and commands are different from standard R graphics. You are encouraged 
to read about this package to discover its strengths and to become aware of it. 
'''
	help(lattice)

	help(package = lattice)

	names(alld)

'''
You can use the 'histogram()' function from the lattice package as below to 
produce an example. This uses data related to income for the 50 states and 
groups information according to the 'region' information. 
'''
	histogram(~stats.Income|region, data=alld, layout=c(1,4))

#Now write the dataset to a CSV file. First open the help guide regarding this function.

	help(write.csv)

'''
Note that R wants the information packaged up in a data frame. Many options are 
available. The following statement instructs R not to quote the data and not to 
export the row names. You should run this function a number of times, changing 
the options.
'''
	write.csv(alld, "alld_datatest.csv", quote=FALSE, row.names=FALSE)

'''
EXERCISES:

	- Determine how to order data by two columns. Then find the 10 state 
	  names with the largest life expectancy and the largest literacy.

#------------------------------------------------------------------------------#
Basics: Dates

This section reviews some basics of working with dates in R. You should 
understand how R expects dates to be formatted and how you can adjust the 
process if your dates are in a different format. Once recognized as dates in R, 
you need to know some basic ways you can work with dates to extract specific 
information or use it for calculations. 
'''
	dlist <- as.Date(c("2007-6-22", "2004-2-13"))
  
  date <- as.Date(1:365, origin ="2015-01-01")

	dlist[1]

	dlist[1]-dlist[2]     # Calculates the number of days between two dates.

	Sys.Date()            # Today's date (YYYY-MM-DD)

	date()                # Gives detailed information on the date and time.

#Dates in R have the default of YYYY-DD-MM, so any other format must be specified.

	dlist2 = as.Date(c("1/5/1965", "8/16/1975"), "%m/%d/%Y")

	dlist2[1]

	dlist3 = as.Date(c("01/05/1965", "08/16/1975"), "%m/%d/%Y")		

#The latter statement shows that 01 is treated the same as 1 for dates.

	help(ISOdatetime)

	x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
	z <- strptime(x, "%d%b%Y")

	help(strptime)        # Converts between character and numeric dates

	z[2]

#Given corresponding vectors of dates and times, you can combine them element by
#element, so dates[i] will be combined with times[i].

	dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
	times <- c("23:03:20", "22:29:56", "01:03:30", "18:21:03", "16:56:26")

	x <- paste(dates, times)

	x[1]

	class(x)

'''
Note that R views these lines as characters rather than dates yet. You must 
specify that you want each element in x to be a date with time information. To 
do this, you can use the 'strptime()' function to specify how the information 
is presented as follows:
'''
                               
	fullinfo = strptime(x, "%m/%d/%y %H:%M:%S")

	fullinfo[2]

	class(fullinfo)       # The dates are no longer in character format.

	today <- Sys.Date()

#Working with dates in R allows other options for creating sequences of dates.

	tenweeks <- seq(today, length.out=10, by="1 week")

	tenweeks <- seq(today, length.out=10, by="3 week")

	tendays <- seq(today, length.out=10, by="3 day")

#Often you will have specific information from which you will want to access a 
date.

	weekdays(today)

	months(tenweeks)

	help(months)

	year.char <- format(Sys.time(), "%Y")

	year.num <- as.numeric(format(tenweeks,"%Y"))

'''
#Some important formats you can use for dates are as follows:

%d - day of month
%H - hour (0-23)
%h - hour (1-12)
%j - day of year
%m - month (1-12)
%M - minute (00-59)
%Y - year with century

EXERCISES:

	- Provide comments explaining the following lines of code. 

		random.dates <- as.Date("2010/1/1") + 200*runif(100)

		class(random.dates)
		
		hist(random.dates, "weeks", format = "%d %b")

	- Given the list of dates contained in 'random.dates', find the set of 
        dates that are a Monday or Friday.

	- Given the list of dates contained in 'random.dates', keep only day, 
        month, and year information. Find a set of unique dates from this list,
        place them in chronological order, and find the distribution of 
	  differences between nearby dates. 

#------------------------------------------------------------------------------#
