/*import 'filterCategory.dart';

// Setting class: ViewCell

class FilterSelector
{
    public event EventHandler<EventArgs> EnabledGroupsChanged;
    Map<String, FilterCategory> categories;
    Map<String, Setting> currentSettings = new Map<String, Setting>();
    Map<String, String> searchResults;
    Map<String, String> enabledGroups;
    Picker filterTypePicker;
    String dataType = "0";
    FilterSelector(Map<String, FilterCategory> categories, Map<String, String> enabledGroups)
    {
        InitializeComponent();
        ToolbarItems.Add(new ToolbarItem
        {
            Text = "Done",
            Command = new Command(() => Navigation.PopModalAsync()),
        });
        filterTypePicker = new Picker();
        filterTypePicker.SelectedIndexChanged += PickerIndexChanged;
        filterTypePicker.SelectedIndexChanged += SearchFilter;
        FilterTypePickerSetting.Picker = filterTypePicker;
        // <local:SubMenuSetting Label="View Results" Tapped="ShowFilteredItems"/>
        SubMenuSetting searchResultsMenu = new SubMenuSetting(Navigation) { Label = "View Results" };
        searchResultsMenu.Tapped += ShowFilteredItems;
        SearchResultsSection.Add(searchResultsMenu);
        foreach (KeyValuePair<string, FilterCategory> category in categories)
        {
            filterTypePicker.Items.Add(category.Key);
        }
        this.categories = categories;
        this.EnabledGroups = enabledGroups;
    }
    // Function is async to run on another thread. Won't actually block GUI.
    public async void PickerIndexChanged(object sender, EventArgs args)
    {
        // Clear search results and 
        searchResults?.Clear();
        Picker picker = sender as Picker;
        string selectedCategory = picker.Items[picker.SelectedIndex];
        FilterCategory selectedFilterCategory = categories[selectedCategory];
        dataType = selectedFilterCategory.Value;
        if (FiltersTableView.Root.Count <= 1) return;
        TableSection section = FiltersTableView.Root[1];
        section.Clear();
        currentSettings.Clear();
        // Add different filters depending on category
        switch (selectedFilterCategory)
        {
            case SearchFilterMultiChoice smfc:
                foreach (KeyValuePair<string, List<FilterCategory>> valuePair in smfc.Filters)
                {
                    List<CheckedListItem> items = new List<CheckedListItem>();
                    MultiSelectSetting multiSelectSetting = new MultiSelectSetting(Navigation) { Label = valuePair.Key };
                    MultiSelectList list = multiSelectSetting.SubMenu as MultiSelectList;
                    list.OnCheckedChanged += SearchFilter;
                    foreach (FilterCategory category in valuePair.Value)
                    {
                        items.Add(new CheckedListItem { Title = category.Name, IsChecked = EnabledGroups.Keys.Contains(category.Name) });
                    }
                    list.ItemsSource = items;
                    //PickerSetting groupPickerSetting = new PickerSetting() { Picker = groupPicker, Label = valuePair.Key };
                    section.Add(multiSelectSetting);
                    currentSettings[valuePair.Key] = multiSelectSetting;
                }
                break;
        }
    }
    // Function is async to run on another thread. Won't actually block GUI.
    async void SearchFilter(object sender, EventArgs args)
    {
        // Run the function asynchronously to prevent GUI blocking
        if (filterTypePicker.SelectedIndex < 0) return;
        string selectedCategory = filterTypePicker.Items[filterTypePicker.SelectedIndex];
        // Dictionary<string: , Dictionary<string: , List<string: >>>
        Dictionary<string, Dictionary<string, List<string>>> items = new Dictionary<string, Dictionary<string, List<string>>>();
        foreach (KeyValuePair<string, Setting> valuePair in currentSettings)
        {
            switch (valuePair.Value)
            {
                case MultiSelectSetting ms:
                    HashSet<string> selectedItems = ((MultiSelectList)ms.SubMenu).checkedItems;
                    if (selectedItems.Count <= 0) continue;
                    List<FilterCategory> filters = ((SearchFilterMultiChoice)categories[selectedCategory]).Filters[ms.Label];
                    foreach (FilterCategory filter in filters)
                    {
                        if (selectedItems.Contains(filter.Name))
                        {
                            if (!items.ContainsKey(filter.DataParam)) items.Add(filter.DataParam, new Dictionary<string, List<string>>());
                            if (!items[filter.DataParam].ContainsKey(filter.DataPrefix)) items[filter.DataParam].Add(filter.DataPrefix, new List<string>());
                            items[filter.DataParam][filter.DataPrefix].Add(filter.Value);
                        }
                    }
                    break;
            }
        }
        searchResults = ScheduleSearch.SearchFilters(dataType, items);
    }
    async void ShowFilteredItems(object sender, EventArgs args)
    {
        // Run the function asynchronously to prevent GUI blocking
        MultiSelectList filteredList = new MultiSelectList();
        filteredList.OnCheckedChanged += OnSelectedItemsChanged;
        if (searchResults == null) filteredList.ItemsSource = new List<CheckedListItem>();
        else
        {
            List<CheckedListItem> items = new List<CheckedListItem>();
            foreach (KeyValuePair<string, string> itemKvp in searchResults)
                items.Add(new CheckedListItem { Title = itemKvp.Key, IsChecked = EnabledGroups.Values.Contains(itemKvp.Value) });
            filteredList.ItemsSource = items;
        }
        await Navigation.PushModalAsync(new NavigationPage(filteredList) { Title = "Item Selection" });
    }
    async void OnSelectedItemsChanged(object sender, EventArgs args)
    {
        // Run the function asynchronously to prevent GUI blocking
        CheckedListItem item = sender as CheckedListItem;
        if (item.IsChecked)
        {
            EnabledGroups.Add(item.Title, searchResults[item.Title]);
        }
        else if (EnabledGroups.ContainsKey(item.Title)) EnabledGroups.Remove(item.Title);
        EnabledGroupsChanged?.Invoke(this, null);
    }
}*/
