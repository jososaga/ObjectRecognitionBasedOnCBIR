function mapclass_deodorant = create_mapping_deodorant()
keySet_deodorant = [1 2 4 5 6 7 8 9];
valueSet_deodorant = cell (numel(keySet_deodorant), 1);
for i=1:numel(keySet_deodorant)
    final_class_temp = sprintf('%05d', keySet_deodorant(i));
    valueSet_deodorant{i} = ['prod' final_class_temp '000'];
end
mapclass_deodorant = containers.Map(keySet_deodorant,valueSet_deodorant);
