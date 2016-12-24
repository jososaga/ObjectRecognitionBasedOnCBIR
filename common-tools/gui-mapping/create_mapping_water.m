function mapclass_water = create_mapping_water()
keySet_water = [1 3 4 6 7 8 9 10 11 12];
valueSet_water = cell (numel(keySet_water), 1);
for i=1:numel(keySet_water)
    final_class_temp = sprintf('%05d', keySet_water(i));
    valueSet_water{i} = ['prod' final_class_temp '000'];
end
mapclass_water = containers.Map(keySet_water,valueSet_water);
