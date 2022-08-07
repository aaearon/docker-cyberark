param(
    $File,
    $ParameterNameValueHashtable
)

$XmlConfig = [xml](Get-Content -Path $File)
foreach ($Parameter in $ParameterNameValueHashtable) {
    $Element = $XmlConfig.SelectSingleNode("//Parameter[@Name='$($Parameter.Name)']")
    $Element.Value = $($Parameter.Value)
}
$XmlConfig.Save($File)
