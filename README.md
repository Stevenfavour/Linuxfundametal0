## CAPSTONE PROJECT
### Bash Scripting for generating a multiplication table. 
In this project, we will be making use of mainly two functions the init_f and init_p for generating a full multiplication table and partial multiplication respectively.


![](/Capstones/Img/A.png)
 The screnshot above represents the function that generates a full multiplication table. 
 The user is prompted to input a number whose multiplication table is to be generated and the also requests if the user wants a full or partial multiplication table for the number value. Both values entered are stored in variables num and F or P respectively as inputed by the user. 

![](/Capstones/Img/B.png)

The init_p() is for generating a partial multiplication table with a upper range value and a lower range value. From the image, both values are requested from the user and a if statement is implemented to ensure the upper range value will always the larger than the lower range value. if this condition is not met, the script prints "Invalid inputs, displaying the full multiplication table" and then we call the init_f() for generating the full multiplication table instead. As seen in both images, the for loop and if statements are written in C-style formats. 

Error handling: How the fuction handles error is shown in the image with an if statement where $up variable has to be greater than $low else full table for $num variable will be automatically generated with a feedback of course. 

![](/Capstones/Img/C.png)
The image above ensure proper error handling if the user fails to input either F or P.
The program echoes a "Invalid input, Enter a valid input"

![](/Capstones/Img/E.png)

After the fuction gen() is called and the multiplication operation is completed, the image above shows the next process to be implemented. It enables the user to enter a new number for another multiplication operation to statr or to quit the script. This part of the script asks the user for a preferred option either to enter new or q as a response. if the user enters new, the script is meant to be repeated freshly and upon pressing q the scripts ends. 

![](/Capstones/Img/F.png)
![](/Capstones/Img/G.png)

#### Results

Requesting a number for its multiplication table to be generated. 

![](/Capstones/Img/AA.png)

![](/Capstones/Img/BB.png)

Prompts the user to specify whether a partial table or full table is to be generated with responses F and P

Provided all necessary conditions are met, 

![](/Capstones/Img/CC.png)

Here, the value new is inputted by the user and the program is ready to accept a new number for processing.

 ![](/Capstones/Img/DD.png)

 This time, the user wants to generate a partial multiplication table by inputting P.

 ![](/Capstones/Img/EE.png)

 User enters the upper rnage value and lower range values. 

  ![](/Capstones/Img/FF.png)

  Ouput for the partial multiplication table 

   ![](/Capstones/Img/GG.png)

   Error handling. 

![](/Capstones/Img/HH.png)

 The script outputs "Invalid nput, enter a valid input" when the user enters rr as an input. 

 ![](/Capstones/Img/II.png)

 Here, the user a lower range value that is larger than the upper range value. 
 Let's checkout what the output would be like. 

 ![](/Capstones/Img/JJ.png) 

 As explained from the script, it prompts the user about the invalid inputs and consequently displaying the full multiplication table as a result.

 ## Task 2
### List Form
 ![](/Capstones/Img/Task2.png) 


 Upon observation, the for loop on line 6 and 24 and the if statement on line 17 are different from the previous statements. This is because we have used to different style format to acheive the same goal as we did in the previous scripts. 