class @WalletSendMethodDialogViewController extends @DialogViewController

  view:
    mobileTableContainer: "#mobile_table_container"
  mobilesGroups: []

  onAfterRender: ->
    super
    @_refreshMobilesList()

  pairMobilePhone: ->
    dialog = new WalletPairingIndexDialogViewController()
    dialog.show()
    dialog.getDialog().once 'dismiss', =>
      @_refreshMobilesList()

  selectMobileGroup: (params) ->
    mobilesGroup = @mobilesGroups[params.index]

  _refreshMobilesList: ->
    ledger.m2fa.PairedSecureScreen.getAllGroupedByUuidFromSyncedStore (mobilesGroups, error) =>
      return if error? or not mobilesGroups?
      mobilesGroups = _.sortBy _.values(_.omit(mobilesGroups, undefined)), (item) -> item[0]?.name
      # render partial
      render "wallet/send/_method_mobiles_list", mobilesGroups: mobilesGroups, (html) =>
        return if not html?
        # retain mobiles
        @mobilesGroups = mobilesGroups
        # clear node
        @view.mobileTableContainer.empty()
        @view.mobileTableContainer.append html