### Create a New User via Azure CLI
```
az ad user create \
  --display-name "AZ104 Test User" \
  --user-principal-name az104testuser@hachibit.org \
  --password "TempP@ssw0rd2024!" \
  --force-change-password-next-sign-in true
```
**Syntax Breakdown:**

- `az ad user create` — calls the Entra ID user creation module via Azure CLI
- `--display-name` — the friendly name shown in the portal and directory
- `--user-principal-name` — the full UPN, must match your verified domain (hachibit.org)
- `--password` — sets the initial password; must meet complexity requirements
- `--force-change-password-next-sign-in true` — forces password reset on first login, Microsoft best practice for new accounts

### Create a Security Group and Add the User
bash

```bash
# Step 1 — Create the security group
az ad group create \
  --display-name "AZ104-StudyGroup" \
  --mail-nickname "AZ104-StudyGroup"
```
**Syntax Breakdown:**

- `az ad group create` — creates a new group in Entra ID
- `--display-name` — the name shown in the portal
- `--mail-nickname` — required field, used as the alias; no spaces allowed

bash

```bash
# Step 2 — Get the user's Object ID
az ad user show \
  --id az104testuser@hachibit.org \
  --query id \
  --output tsv
```

**Syntax Breakdown:**

- `az ad user show` — retrieves the user object from Entra ID
- `--id` — accepts UPN or Object ID as the identifier
- `--query id` — uses JMESPath to extract only the `id` field from the JSON response
- `--output tsv` — returns plain text instead of JSON, making it easy to copy the value

bash

```bash
# Step 3 — Add user to the group (replace <object-id> with the output above)
az ad group member add \
  --group "AZ104-StudyGroup" \
  --member-id <object-id>
```

**Syntax Breakdown:**

- `az ad group member add` — adds a member to an existing Entra ID group
- `--group` — references the group by display name or Object ID
- `--member-id` — the Object ID of the user being added

### Verify Your Work

bash

```bash
# Verify user exists
az ad user list \
  --filter "startswith(displayName,'AZ104')" \
  --query "[].{Name:displayName, UPN:userPrincipalName}" \
  --output table
```

**Syntax Breakdown:**

- `--filter` — applies an OData filter to the directory query, reducing returned results
- `--query` — reshapes the JSON output using JMESPath; `[]` iterates the array, `{}` builds a custom object
- `--output table` — formats the result as a clean readable table

bash

````bash
# Verify group membership
az ad group member list \
  --group "AZ104-StudyGroup" \
  --query "[].{Name:displayName, UPN:userPrincipalName}" \
  --output table
```

**Expected Output:**
```
Name              UPN
----------------  ----------------------------
AZ104 Test User   az104testuser@hachibit.org
```

---

## ☑️ ITEM 2: RBAC — Roles, Scopes & Custom Definitions

### Concept Brief — The Scope Hierarchy

This is one of the most tested concepts on the entire exam. Memorize this hierarchy:
```
Management Group
    └── Subscription
            └── Resource Group
                    └── Resource
````

**Key Rules:**

- Assignments made at a **higher scope inherit downward**
- You cannot assign a role at a scope higher than its `AssignableScopes` definition
- RBAC is **additive** — multiple role assignments stack permissions
- A **deny assignment** overrides all role assignments — deny always wins

### The Three Roles You Must Know Cold

|Role|What It Can Do|What It Cannot Do|
|---|---|---|
|**Owner**|Everything including role assignments|Nothing — full control|
|**Contributor**|Create and manage all resources|Cannot assign roles or manage access|
|**Reader**|View all resources|Cannot make any changes|