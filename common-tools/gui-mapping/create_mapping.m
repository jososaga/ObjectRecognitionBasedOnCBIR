function mapclass = create_mapping(category_name)

switch category_name
    case 'euro'
        mapclass = create_mapping_euro();
    case 'cereale'
        mapclass = create_mapping_cereal();
    case 'medicina'
        mapclass = create_mapping_medicine();
    case 'lattina'
        mapclass = create_mapping_cans();
    case 'deodorante'
        mapclass = create_mapping_deodorant();
    case 'pomodoro'
        mapclass = create_mapping_tomatos();
    case 'acqua'
        mapclass = create_mapping_water();
    otherwise
        mapclass = [];
end