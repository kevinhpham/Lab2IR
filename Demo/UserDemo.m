classdef UserDemo
   properties
      mealSelected;
      juiceSelected;
   end

   methods
       function self = UserDemo()
			    self.selectMeal();
                self.selectJuice();
       end
   end

   methods(Static)
      function selectMeal()
         disp("Would you like a Vegetarian or Meat Meal?")
         mealChoice = input("Enter 'V' for Veg or 'M' for Meat ", "s");
         %mealSelected = ['The meal you selected is ', mealChoice];
         %disp(mealSelected)

         if mealChoice == 'V' || mealChoice == 'M'
             mealSelected = ['The meal you selected is ', mealChoice];
             disp(mealSelected)
         else
             disp('Input is not valid')
         end
      end

      function selectJuice()
         disp("Would you like a Blackcurrent or Orange Juice?")
         juiceChoice = input("Enter 'B' for Blackcurrent or 'O' for Orange ", "s");
         %mealSelected = ['The meal you selected is ', mealChoice];
         %disp(mealSelected)

         if juiceChoice == 'B' || juiceChoice == 'O'
             juiceSelected = ['The juice you selected is ', juiceChoice];
             disp(juiceSelected)
         else
             disp('Input is not valid')
         end
      end

   end
end