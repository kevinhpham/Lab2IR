classdef UserDemo
    % The purpose of this class is to demonstrate a user order interface 
    % The function provides prompts to the user to create a custom meal
    % After receiving inputs from the user, the function prints out the
    % order to the command window

   properties
      mealResult;   % To store result: Vegetarian or Meat
      juiceResult;  % To store result: Blackcurrent or Orange
   end

   methods
       function self = UserDemo()
           self.customiseMealTray()
       end
   end

   methods(Static)
      function customiseMealTray()
         % Select the Meal
         disp("Would you like a Vegetarian or Meat Meal?")
         mealChoice = input("Enter 'V' for Veg or 'M' for Meat ", "s");
         if mealChoice == 'V' || mealChoice == 'v'      % Input is not case sensitive
             mealChoice = 'Vegetarian';                 % Convert letter to full word
         elseif mealChoice == 'M'|| mealChoice == 'm'   
             mealChoice = 'Meat';                       % Convert letter to full word
         else
             disp('Input is not valid') % Cannot input a number or character other than those specified.
         end

         % Select the juice
         disp("Would you like a Blackcurrent or Orange Juice?")
         juiceChoice = input("Enter 'B' for Blackcurrent or 'O' for Orange ", "s");

         if juiceChoice == 'B' || juiceChoice == 'b'    % Input is not case sensitive
             juiceChoice = 'Blackcurrent';              % Convert letter to full word
         elseif juiceChoice == 'o'|| juiceChoice == 'O'
             juiceChoice = 'Orange';                    % Convert letter to full word
         else
             disp('Input is not valid') % Cannot input a number or character other than those specified.
         end
         
         disp(' ')
         input("Press enter to display your custom meal", "s"); % Mimic user interface

         % Display Customised Meal Result
         disp(' ')
         disp('Your Customised Meal Tray')
         mealResult = ['Meal: ', mealChoice];
         juiceResult = ['Juice: ', juiceChoice];
         disp(mealResult)
         disp(juiceResult)
         disp('cutlery')

         disp(' ')
         input("Press enter to send order to kitchen", "s"); % Mimic user interface
         disp(' ')
         disp('Thank you! Your order has been sent to the kitchen.')
      end

   end
end