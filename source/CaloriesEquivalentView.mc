using Toybox.WatchUi;
using Toybox.Lang;

class CaloriesEquivalentView extends WatchUi.SimpleDataField {

	protected var calories = 0;
	protected var text = 0;

	function initialize() {
		SimpleDataField.initialize();
		label = "Calories";
	}

	function compute(info) {
		if (info has :calories && info.calories != null && info.calories > 0) {
			if (self.calories != info.calories) {
				self.calories = info.calories;
				self.text = self.format(info.calories);
			}
			return self.text;
		}

		return "0";
	}

	protected var equivalents = {
		// https://www.nutritionix.com/
		"1" => {
			"1" => "$1$ raspberry",
			"+" => "$1$ raspberries",
		},
		"2" => {
			"1" => "$1$ strawberry",
			"+" => "$1$ strawberries",
		},
		"3" => {
			"1" => "$1$ M&M",
			"+" => "$1$ M&M's",
		},
		"4" => {
			"1" => "$1$ Skittle",
			"+" => "$1$ Skittles",
		},
		"8" => {
			"1" => "$1$ french fry",
			"+" => "$1$ french fries",
		},
		"9" => {
			"1" => "$1$ gummy bear",
			"+" => "$1$ gummy bears",
		},
		"15" => {
			"1" => "$1$ potato chip",
			"+" => "$1$ potato chips",
		},
		"22" => {
			"1" => "$1$ tomato",
			"+" => "$1$ tomatoes",
		},
		"30" => {
			"1" => "$1$ carrot",
			"+" => "$1$ carrots",
		},
		"70" => {
			"1" => "$1$ fish stick",
			"+" => "$1$ fish sticks",
		},
		"72" => {
			"1" => "$1$ whiskey",
			"+" => "$1$ whiskeys",
		},
		"77" => {
			"1" => "$1$ bread slice",
			"+" => "$1$ bread slices",
		},
		"85" => {
			"1" => "$1$ red wine",
			"+" => "$1$ red wines",
		},
		"80" => {
			"1" => "$1$ pancake",
			"+" => "$1$ pancakes",
		},
		"90" => {
			"1" => "$1$ fried egg",
			"+" => "$1$ fried eggs",
		},
		"95" => {
			"1" => "$1$ apple",
			"+" => "$1$ apples",
		},
		"100" => {
			"1" => "$1$ energy gel",
			"+" => "$1$ energy gels",
		},
		"105" => {
			"1" => "$1$ banana",
			"+" => "$1$ bananas",
		},
		"120" => {
			"1" => "$1$ cup of milk",
			"+" => "$1$ cups of milk",
		},
		"140" => {
			"1" => "$1$ Coca Cola",
			"+" => "$1$ Coca Colas",
		},
		"150" => {
			"1" => "$1$ beer",
			"+" => "$1$ beers",
		},
		"161" => {
			"1" => "$1$ potato",
			"+" => "$1$ potatoes",
		},
		"180" => {
			"1" => "$1$ cookie",
			"+" => "$1$ cookies",
		},
		"200" => {
			"1" => "$1$ bagel",
			"+" => "$1$ bagels",
		},
		"200" => {
			"1" => "$1$ taco",
			"+" => "$1$ tacos",
		},
		"216" => {
			"1" => "$1$ chicken wing",
			"+" => "$1$ chicken wings",
		},
		"225" => {
			"1" => "$1$ cup of rice",
			"+" => "$1$ cups of rice",
		},
		"245" => {
			"1" => "$1$ waffle",
			"+" => "$1$ waffles",
		},
		"253" => {
			"1" => "$1$ donut",
			"+" => "$1$ donuts",
		},
		"227" => {
			"1" => "$1$ avocado",
			"+" => "$1$ avocados",
		},
		"273" => {
			"1" => "$1$ ice cream",
			"+" => "$1$ ice creams",
		},
		"290" => {
			"1" => "$1$ pizza slice",
			"+" => "$1$ pizza slices",
		},
		"300" => {
			"1" => "$1$ apple pie slice",
			"8" => "$1$ apple pie",
			"+" => "$1$ apple pie slices",
		},
		"316" => {
			"1" => "$1$ hot dog",
			"+" => "$1$ hot dogs",
		},
		"460" => {
			"+" => "$1$ mac & cheese",
		},
		"540" => {
			"1" => "$1$ Big Mac",
			"+" => "$1$ Big Macs",
		},
		"610" => {
			"1" => "$1$ steak",
			"+" => "$1$ steaks",
		},
		"670" => {
			"+" => "$1$ spaghetti",
		},
		"870" => {
			"1" => "$1$ sub sandwich",
			"+" => "$1$ sub sandwiches",
		},
		"993" => {
			"1" => "$1$ Pringles can",
			"+" => "$1$ Pringles cans",
		},
		"1150" => {
			"1" => "$1$ cheese steak",
			"+" => "$1$ cheese steaks",
		},
	};

	function format(calories) {
		var prev = 0;
		for (var i = 1; i <= calories; i += 1) {
			var value = Math.round(calories / i);
			if (value == prev) {
				// no point in looking up closest match if we've just checked it...
				continue;
			}
			prev = value;

			// find the closest match & the amount of it most closely matching the
			// current amount of calories
			var closest = self.getClosest(value);
			var amount = Math.round(calories / closest);

			var difference = calories - amount * closest;
			if (calories * 0.02 > difference.abs()) {
				// if we've found a match within 2% of what we're looking for, that's
				// good enough!
				return self.pluralize(closest, amount);
			}
		}

		return "";
	}

	function getClosest(calories) {
		var list = self.equivalents.keys();

		var prev = 0;
		var next = list[list.size() - 1].toNumber();
		for (var i = 0; i < list.size(); i++) {
			var current = list[i].toNumber();
			if (current <= calories && current > prev) {
				prev = current;
			}
			if (current >= calories && current < next) {
				next = current;
			}
		}

		return calories - prev < next - calories ? prev : next;
	}

	function pluralize(calories, amount) {
		var stringAmount = amount.toString();
		var stringCalories = calories.toString();

		var plurals = self.equivalents[stringCalories];
		if (plurals.hasKey(stringAmount)) {
			return Lang.format(plurals[stringAmount], [stringAmount]);
		}
		if (plurals.hasKey("+")) {
			return Lang.format(plurals["+"], [stringAmount]);
		}

		throw new Lang.Exception(/* Missing plural */);
	}

}