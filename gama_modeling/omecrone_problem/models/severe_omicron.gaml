/**
* Name: severeomicron
* Based on the internal empty template. 
* Author: bouhm
* Tags: 
*/


model severeomicron

/* Insert your model definition here */

global {
	file shape_file_buildings <- file("../includes/building.shp");
	file shape_file_roads <- file("../includes/road.shp");
	file shape_file_bounds <- file("../includes/bounds.shp");
	geometry shape <- envelope(shape_file_bounds);
	float step <- 3 #mn;
	date starting_date <- date("2024-02-24-15-08-00");	
	int nb_Humain <- 100;
	int min_work_start <- 6;
	int max_work_start <- 8;
	int min_work_end <- 16; 
	int max_work_end <- 20; 
	float min_speed <- 1.0 #km / #h;
	float max_speed <- 5.0 #km / #h; 
	int repair_time <- 2 ;
	graph the_graph;
	
	init {
		write starting_date;
		create building from: shape_file_buildings with: [type::string(read ("NATURE"))] {
			if type="Industrial" {
				color <- #blue ;
			}
		}
		create road from: shape_file_roads ;
		map<road,float> weights_map <- road as_map (each:: (each.destruction_coeff * each.shape.perimeter));
		the_graph <- as_edge_graph(road) with_weights weights_map;
		
		
		list<building> residential_buildings <- building where (each.type="Residential");
		list<building> industrial_buildings <- building  where (each.type="Industrial") ;
		create Humain number: nb_Humain {
			speed <- rnd(min_speed, max_speed);
			start_work <- rnd (min_work_start, max_work_start);
			end_work <- rnd(min_work_end, max_work_end);
			living_place <- one_of(residential_buildings) ;
			working_place <- one_of(industrial_buildings) ;
			objective <- "resting";
			location <- any_location_in (living_place); 
			is_ill <- flip(0.1);
		}
	}
	
	reflex update_graph{
		map<road,float> weights_map <- road as_map (each:: (each.destruction_coeff * each.shape.perimeter));
		the_graph <- the_graph with_weights weights_map;
	}
	reflex repair_road when: every(repair_time #hour ) {
		road the_road_to_repair <- road with_max_of (each.destruction_coeff) ;
		ask the_road_to_repair {
			destruction_coeff <- 1.0 ;
		}
	}
}

species building {
	string type; 
	rgb color <- #gray  ;
	
	aspect base {
		draw shape color: color ;
	}
}

species road  {
	float destruction_coeff <- rnd(1.0,2.0) max: 2.0;
	int colorValue <- int(255*(destruction_coeff - 1)) update: int(255*(destruction_coeff - 1));
	rgb color <- rgb(min([255, colorValue]),max ([0, 255 - colorValue]),0)  update: rgb(min([255, colorValue]),max ([0, 255 - colorValue]),0) ;
	
	aspect base {
		draw shape color: color ;
	}
}

species Humain skills:[moving]
{
	bool unvaccination;
	bool eff_vaccinated;
	bool half_vaccinated;
	building living_place <- nil ;
	building working_place <- nil ;
	int start_work ;
	int end_work  ;
	string objective ; 
	point the_target <- nil ;
	bool is_ill ;
	reflex deplacement 
	{
//location <-any_location_in(world);
do wander speed: 200#km/#hour amplitude: 180;	
}

reflex contamine 
{
	half_vaccinated <- flip(0.2);
	eff_vaccinated <- flip(0.7);
	unvaccination <- flip(0.1);
	
list<Humain> voisins <- Humain at_distance 1#m where is_ill;
write length(voisins);
ask voisins{
    is_ill <- true;   	
	if(unvaccination = false){
		is_ill <- true;
	}	
	if(eff_vaccinated = false)
	{
		is_ill <- true;
	}
	if(half_vaccinated = false)
	{
		is_ill <- true;
	}
	}	
}
reflex time_to_work when: current_date.hour = start_work and objective = "resting"{
		objective <- "working" ;
		the_target <- any_location_in (working_place);
	}
		
	reflex time_to_go_home when: current_date.hour = end_work and objective = "working"{
		objective <- "resting" ;
		the_target <- any_location_in (living_place); 
	} 
	 	reflex move when: the_target != nil {
		path path_followed <- goto(target:the_target, on:the_graph, return_path: true);
		list<geometry> segments <- path_followed.segments;
		loop line over: segments {
			float dist <- line.perimeter;
			ask road(path_followed agent_from_geometry line) { 
			}
		}
		if the_target = location {
			the_target <- nil ;
		}
	}
	
aspect base1
{
//draw shape border:#red wireframe:true;
if(is_ill = false)
{
draw circle(20#m) color:#green;
}
else{
draw circle(10#m)color:#red;
}	
}
}

experiment severe_omicrone type: gui {
	parameter "Shapefile for the buildings:" var: shape_file_buildings category: "GIS" ;
	parameter "Shapefile for the roads:" var: shape_file_roads category: "GIS" ;
	parameter "Shapefile for the bounds:" var: shape_file_bounds category: "GIS" ;
	parameter "Number of Humain agents" var: nb_Humain category: "Humain" ;
	parameter "Earliest hour to start work" var: min_work_start category: "Humain" min: 2 max: 8;
	parameter "Latest hour to start work" var: max_work_start category: "Humain" min: 8 max: 12;
	parameter "Earliest hour to end work" var: min_work_end category: "Humain" min: 12 max: 16;
	parameter "Latest hour to end work" var: max_work_end category: "Humain" min: 16 max: 23;
	parameter "minimal speed" var: min_speed category: "Humain" min: 0.1 #km/#h ;
	parameter "maximal speed" var: max_speed category: "Humain" max: 10 #km/#h;
	parameter "Number of hours between two road repairs" var: repair_time category: "Road" ;
	
	output {
		display city_display type:3d {
			species building aspect: base ;
			species road aspect: base ;
			species Humain aspect: base1 ;
		}
	display chart refresh:every(10 #cycles){
	chart "Disease spreading" type: series{
	data "susceptible" value: Humain count(each.is_ill=false)
	color: #green marker: false;
	data "infected" value: Humain count(each.is_ill=true)
	color: #red marker: false;}}

	}
}