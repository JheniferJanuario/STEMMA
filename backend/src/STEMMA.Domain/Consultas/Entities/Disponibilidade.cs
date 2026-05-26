namespace STEMMA.Domain.Consultas.Entities;

public class Disponibilidade
{
    public Guid Id { get; private set; }

    public string Veterinario { get; private set; }

    public DateTime DataInicio { get; private set; }

    public DateTime DataFim { get; private set; }

    protected Disponibilidade() { }

    public Disponibilidade(
        string veterinario,
        DateTime dataInicio,
        DateTime dataFim)
    {
        Validar(veterinario, dataInicio, dataFim);

        Id = Guid.NewGuid();
        Veterinario = veterinario;
        DataInicio = dataInicio;
        DataFim = dataFim;
    }

    private void Validar(
        string veterinario,
        DateTime dataInicio,
        DateTime dataFim)
    {
        if (string.IsNullOrWhiteSpace(veterinario))
            throw new Exception("Veterinário obrigatório.");

        if (dataFim <= dataInicio)
            throw new Exception("Data final deve ser maior que a inicial.");
    }
}