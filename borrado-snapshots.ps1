#Archivo donde van a estar las VM's
$lista = Get-Content C:\vms.txt

#Se procesan las VM's de una en una
foreach ($vmName in $lista) {

    #Santidad de tareas simultaneas (empieza desde 0, para el caso de querer 3, se pondria 2)
    $maxtasks = 2

    write-host $vmName -ForegroundColor Yellow

    #Se setea el tiempo de las snapshopts a borrar hacia atras (en negativo)
    $snaps = Get-VM $vmName | Get-Snapshot | Where { $_.Created -lt (Get-Date).AddDays(-7)}

    $i = 0

    while($i -lt $snaps.Count){

    Remove-Snapshot -Snapshot $snaps[$i] -RunAsync -Confirm:$false
    sleep 10

    $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}

    while($tasks.Count -gt ($maxtasks-1)) {

    sleep 20

    $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}

     }
     $i++
    }
}
