<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Picker.ascx.cs" Inherits="CPP.NewPlatform.ProductPicker.Picker" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<div id="Div1" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            if (document.getElementById('<%=ProductId.ClientID%>').value == "") {
                document.getElementById('delete').style.visibility = 'hidden';
            }
            else {
                document.getElementById('delete').style.visibility = 'visible';
            }
        }
        function onChoose(e) {
            var oWnd = $find("<%=RadWindow1.ClientID%>");
            oWnd.show();
        }
        function onDelete() {
            document.getElementById('<%=ProductName.ClientID%>').value = "";
            document.getElementById('<%=ProductId.ClientID%>').value = "";
            document.getElementById('<%=editorLabel.ClientID%>').innerHTML = "No product selected";
            document.getElementById('delete').style.visibility = 'hidden';
        }
        function onSelect(e) {
            var grid = $find('<%= RadGrid1.ClientID %>');
            var MasterTable = grid.get_masterTableView();
            var row, name, productId;

            var selectedRows = MasterTable.get_selectedItems();
            for (var i = 0; i < selectedRows.length; i++) {
                row = selectedRows[i];
                name = MasterTable.getCellByColumnUniqueName(row, "Name");
                productId = MasterTable.getCellByColumnUniqueName(row, "ProductId");
            }
            if (name != null) {
                document.getElementById('<%=ProductName.ClientID%>').value = name.innerHTML;
                document.getElementById('<%=ProductId.ClientID%>').value = productId.innerHTML;
                document.getElementById('<%=editorLabel.ClientID%>').innerHTML = "Selected Product: " + name.innerHTML;
            }
            var oWnd = $find("<%=RadWindow1.ClientID%>");
            oWnd.hide();
            document.getElementById('delete').style.visibility = 'visible';
        }
        function onCancel(e) {
            var oWnd = $find("<%=RadWindow1.ClientID%>");
            oWnd.hide();
        }
        function onSearchByName() {
            var searchString = $('#searchname').val();
            $('#searchcode').val('');
            AddFilterExpression(searchString, "Name");
        }
        function onSearchByCode() {
            var searchString = $('#searchcode').val();
            $('#searchname').val('');
            AddFilterExpression(searchString, "Code");
        }
        function RadGrid_OnCommand(sender, args) {
            //intentionally left blank 
        }
        function AddFilterExpression(searchString, fieldName) {
            var grid = $find('<%= RadGrid1.ClientID %>');
            grid.get_masterTableView()._filterExpressions.clear();

            var filterExpression = new Telerik.Web.UI.GridFilterExpression();
            var column = grid.get_masterTableView().getColumnByUniqueName(fieldName);
            column.set_filterFunction("Contains");
            filterExpression.set_fieldName(fieldName);
            filterExpression.set_fieldValue(searchString);
            filterExpression.set_filterFunction("Contains");
            filterExpression.set_columnUniqueName(fieldName);
            grid.get_masterTableView()._updateFilterControlValue(searchString, fieldName, "Contains");
            grid.get_masterTableView()._filterExpressions.add(filterExpression);

            grid.get_masterTableView().rebind();
        }
    </script>
</div>
<telerik:RadWindow ID="RadWindow1" runat="server" VisibleStatusbar="false" VisibleTitlebar="false"
    Width="800px" Height="465px">
    <ContentTemplate>
        <asp:UpdatePanel ID="Updatepanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <p>
                    <input type="text" id="searchname" placeholder="Search by name" /><input id="searchByName"
                        type="button" value="Search by Name" onclick="onSearchByName()" /><input type="text" id="searchcode" placeholder="Search by code" /><input id="searchByCode"
                        type="button" value="Search by Code" onclick="onSearchByCode()" />
                </p>
                <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
                    <AjaxSettings>
                        <telerik:AjaxSetting AjaxControlID="RadGrid1">
                            <UpdatedControls>
                                <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                            </UpdatedControls>
                        </telerik:AjaxSetting>
                    </AjaxSettings>
                </telerik:RadAjaxManager>
                <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="Default">
                </telerik:RadAjaxLoadingPanel>
                <telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="true" CellSpacing="0"
                    GridLines="None" AutoGenerateColumns="False" EnableViewState="false" AllowFilteringByColumn="false">
                    <ClientSettings>
                        <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                        <Selecting AllowRowSelect="True" />
                        <ClientEvents OnCommand="RadGrid_OnCommand" />
                        <DataBinding Location="services/GridService.asmx" SelectMethod="GetDataAndCount">
                        </DataBinding>
                    </ClientSettings>
                    <MasterTableView EnableNoRecordsTemplate="true" ShowHeadersWhenNoRecords="true" TableLayout="Fixed">
                        <NoRecordsTemplate>
                            <div>
                                No products</div>
                        </NoRecordsTemplate>
                        <Columns>
                            <telerik:GridBoundColumn UniqueName="ProductId" SortExpression="ProductId" HeaderText="ProductId"
                                DataField="ProductId" Display="false">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="Name" SortExpression="Name" HeaderText="Name"
                                DataField="Name">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="SearchName" SortExpression="SearchName" HeaderText="Search Name"
                                DataField="SearchName">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="Description" SortExpression="Description" HeaderText="Description"
                                DataField="Description">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="Price" SortExpression="Price" HeaderText="Price"
                                DataField="Price">
                            </telerik:GridBoundColumn>
                            <telerik:GridBoundColumn UniqueName="Code" SortExpression="Code" HeaderText="Code"
                                DataField="Code">
                            </telerik:GridBoundColumn>
                        </Columns>
                    </MasterTableView>
                    <SelectedItemStyle BackColor="Fuchsia" BorderColor="Purple" BorderStyle="Dashed"
                        BorderWidth="1px" />
                    <FilterMenu EnableImageSprites="False">
                    </FilterMenu>
                </telerik:RadGrid>
            </ContentTemplate>
        </asp:UpdatePanel>
        <input id="select" type="button" value="Select" onclick="onSelect()" />
        <input id="cancel" type="button" value="Cancel" onclick="onCancel()" />
    </ContentTemplate>
</telerik:RadWindow>
<asp:HiddenField ID="ProductName" runat="server"></asp:HiddenField>
<asp:HiddenField ID="ProductId" runat="server"></asp:HiddenField>
<asp:Label ID="editorLabel" runat="server"></asp:Label><br />
<a href="#" onclick="onChoose()">Choose...</a>
<a id="delete" href="#" onclick="onDelete()">Delete</a>